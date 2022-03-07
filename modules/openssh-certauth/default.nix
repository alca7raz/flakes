{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.openssh.certAuth;
in {
  options.services.openssh.certAuth = {
    enable = mkEnableOption "SSH certificate authentication";

    hostCertificate = mkOption {
      type = with types; nullOr path;
      default = null;
      description = "Host Certificate File";
    };

    userCAKey = mkOption {
      type = with types; nullOr path;
      default = null;
      description = "User CA Publickey File";
    };
  };
  
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.openssh.startWhenNeeded;
        message = "SSH CertAuth: sshd socket activation is not supported。";
      }
      {
        assertion = !cfg.hostCertificate;
        message = "SSH CertAuth: Host Certificate is required when CA is enabled.";
      }
    ];

    services.openssh.extraConfig = ''
      HostCertificate ${cfg.hostCertificate}
    '' + if cfg.userCAKey then ''
      TrustedUserCAKeys ${cfg.userCAKey}
    '' else "";
  };
}
