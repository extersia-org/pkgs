{
  lib,
  config,
  extpkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;

  cfg = config.programs.bellado;
in
{
  options.programs.bellado = {
    enable = mkEnableOption "a fast and once simple cli todo tool";

    enableAliases = mkEnableOption "recommended bellado aliases";
  };

  config = mkIf cfg.enable {
    home.packages = [ extpkgs.bellado ];

    home.shellAliases = optionalAttrs cfg.enableAliases {
      bel = "bellado";
      bell = "bellado -l";
      bella = "bellado -la";
      bellc = "bellado -lc";
    };
  };
}
