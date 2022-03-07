{
  nixosSystem = { self }: {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      self.nixosModules.nginx
      self.nixosModules.postgresql
      self.nixosModules.utils
      self.nixosModules.sops
      ({ config, pkgs, ... }:{
        networking.hostName = "nixos";
      })
    ];
  };

  Host = {
    hostName = "192.168.40.130";
    sshPort = 22;
  };
}

