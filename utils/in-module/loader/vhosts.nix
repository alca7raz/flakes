{ config, pkgs, lib, ... }:
with lib;
let
  vhost_set = builtins.readDir ( ../../../config/websites );
  Vhosts = lib.forEach (lib.subtractLists ["default.nix"] (lib.fold (x: y: if vhost_set.${x} == "regular" then [x] ++ y else y) [] 
    (builtins.attrNames vhost_set))) (x: lib.removeSuffix ".nix" x);
in {
  options.utils.vhosts = mkOption {
    type = with types; nullOr (listOf (enum Vhosts));
    default = [];
    description = "Profile names of the websites which will be deployed on the system.";
  };
  options.utils.defaultVhost = mkOption {
    type = with types; bool;
    default = true;
    description = "Profile names of the websites which will be deployed on the system.";
  };

  config.services.nginx.virtualHosts = lib.fold (x: y: rec { ${x} = import ../../../config/websites/${x}.nix; } // y) {} 
    (if config.utils.defaultVhost then (config.utils.vhosts ++ ["default"]) else config.utils.vhosts);
}
