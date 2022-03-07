{
  description = "Demo Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      lib = nixpkgs.lib;
      utils = import ./utils { inherit lib self nixpkgs inputs; };
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            inputs.colmena.overlay
          ];
        };
      in rec {
        packages = pkgs // {  };

        devShell = with pkgs; mkShell {
          nativeBuildInputs = [ colmena ];
        };
      }
    ) // {

      nixosModules = utils.Module // utils.loader.nixosModules // {
        sops = inputs.sops-nix.nixosModules.sops;
      };

      nixosConfigurations = utils.loader.profiles.nixosConfigurations;

      colmena = {
        meta.nixpkgs = import nixpkgs {
            system = "x86_64-linux";
        };
      } // lib.mapAttrs
        (n: { modules, hostName, sshPort ? utils.port.SSH.normal, ... }: {
          deployment = {
            targetHost = hostName;
            targetPort = sshPort;
            targetUser = "root";
          };

          imports = modules;
        }) utils.loader.profiles.colmena;
      
    };
}
