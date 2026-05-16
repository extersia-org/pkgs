{ extersia }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.quoteit;
in
{
  options.services.quoteit = {
    enable = lib.mkEnableOption "Enable quoteit service";

    package = lib.mkOption {
      type = lib.types.package;
      default = extersia.packages.${pkgs.stdenv.hostPlatform.system}.quoteit;
      description = "The package to use for quoteit";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The port to host the service on";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      quoteit = {
        description = "quoteit";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "quoteit";
          ExecStart = "${lib.getExe cfg.package} serve --addr ':${toString cfg.port}'";
          Restart = "always";

          # hardening
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictNamespaces = "uts ipc pid user cgroup";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
          UMask = "0077";
        };
      };
    };
  };
}
