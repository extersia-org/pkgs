{
  lib,
  pkgs,
  config,
  extpkgs,
  ...
}:
let
  cfg = config.services.snot;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "snot.toml" cfg.settings;
in
{
  options.services.snot = {
    enable = mkEnableOption "snot, a tangled knot backed by Forgejo";

    package = mkPackageOption extpkgs "snot" { };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          db_dsn = mkOption {
            default = "postgres://snot@/forgejo?host=/run/postgresql";
            description = "the db connection to use";
          };

          listen_addr = mkOption {
            default = "0.0.0.0:5555";
            description = "the address to listen on";
          };

          repo_root = mkOption {
            default = "/var/lib/forgejo/repositories";
            description = "the location of the forgejo repositories";
          };
        };
      };

      description = ''
        The configuration for snot.
      '';
    };

    forgejoGroup = mkOption {
      type = lib.types.str;
      default = "forgejo";
      description = "Group with read access to the repository root.";
    };

    environmentFiles = mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files to load environment variables from. `SNOT_*` variables override
        the corresponding TOML keys; use them for secrets such as a `db_dsn`
        with a password.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.snot = {
      description = "tangled knot shim backed by Forgejo";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "postgresql.service"
      ];
      path = [ pkgs.git ];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} serve --config ${configFile}";
        EnvironmentFile = cfg.environmentFiles;

        DynamicUser = true;
        SupplementaryGroups = [ cfg.forgejoGroup ];
        StateDirectory = "snot";
        StateDirectoryMode = "0700";

        Restart = "on-failure";

        # hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadOnlyPaths = [ cfg.settings.repo_root ];
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };
}
