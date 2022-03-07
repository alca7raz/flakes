{ config, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  time.timeZone = "Asia/Shanghai";

  networking.firewall.enable = false;
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  users.users.nomad = {
    createHome = true;
    group = "users";
    extraGroups = [ "wheel" ];
    home = "/home/nomad";
    isNormalUser = true;
    initialPassword = "asdd";
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
