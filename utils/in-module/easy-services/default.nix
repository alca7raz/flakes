# https://github.com/NickCao/flakes/blob/master/modules/cloud/services.nix
{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.easyx;
  serviceOptions = { name, config, ... }: {
    options = {
      exec = mkOption {
        type = types.str;
      };
      env = mkOption {
        type = with types; attrsOf (nullOr (oneOf [ str path package ]));
        default = { };
      };
      envFile = mkOption {
        type = with types; nullOr path;
        default = null;
      };
      creds = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
      };
    };
  };
  mkService = { ExecStart, environment ? null, EnvironmentFile ? null, LoadCredential ? null }: {
    inherit environment;
    serviceConfig = {
      MemoryLimit = "300M";
      DynamicUser = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      PrivateUsers = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectProc = "invisible";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      CapabilityBoundingSet = "";
      ProtectHostname = true;
      ProcSubset = "pid";
      SystemCallArchitectures = "native";
      UMask = "0077";
      SystemCallFilter = "@system-service";
      SystemCallErrorNumber = "EPERM";
      Restart = "always";
      inherit ExecStart EnvironmentFile LoadCredential;
    };
    wantedBy = [ "multi-user.target" ];
  };
in {
  options.easyx.services = mkOption {
    default = { };
    type = with types; attrsOf (submodule serviceOptions);
  };
  config.systemd.services = builtins.mapAttrs (name: v: mkService {
      ExecStart = v.exec;
      environment = v.env;
      EnvironmentFile = v.envFile;
      LoadCredential = v.creds;
    }) cfg.services;
}
