{
  nixosSystem = { self }: {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      self.nixosModules.nginx
      self.nixosModules.utils
      ({ config, pkgs, ... }:{
        networking.hostName = "test";
        utils.defaultVhost = false;
        utils.vhosts = [ "test" ];
      })
    ];
  };

  Host = {
    hostName = "192.168.40.131";
    sshPort = 22;
  };
}


