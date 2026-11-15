{
  lib,
  extpkgs,
  config,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;

  cfg = config.services.lethe-server;
in
{
  options.services.lethe-server = {
    enable = mkEnableOption "the lethe sync server";

    package = mkPackageOption extpkgs "lethe" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the port on every interface. Prefer opening it on a private interface yourself.";
    };

    settings = {
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      port = mkOption {
        type = types.port;
        default = 7374;
        description = "Port to listen on.";
      };

      tokenFile = mkOption {
        type = types.path;
        description = ''
          File containing the shared bearer token that clients pass to `lethe sync`.
          Read through systemd credentials, so it may be owned by root.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lethe-server = {
      description = "lethe sync server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        LETHE_DB = "/var/lib/lethe/lethe.db";
        LETHE_LISTEN = "${cfg.settings.listenAddress}:${toString cfg.settings.port}";
        NO_COLOR = "1";
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --token-file \${CREDENTIALS_DIRECTORY}/token";
        LoadCredential = "token:${cfg.settings.tokenFile}";
        DynamicUser = true;
        StateDirectory = "lethe";
        Restart = "on-failure";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];
  };
}
