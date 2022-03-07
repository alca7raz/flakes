{ config, pkgs, lib, ... }:
{
  #imports = import ../../utils/nginx-vhosts { inherit lib; };

  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedOptimisation  = true;
    recommendedGzipSettings  = true;
    recommendedProxySettings = true;
    recommendedTlsSettings   = true;
  };
}
