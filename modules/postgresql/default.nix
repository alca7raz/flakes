{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;

    enableTCPIP = true;

    dataDir = /var/lib/postgresql/data;
  };
}
