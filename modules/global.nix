{ extersiaModules }:
{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.extersia.cache.enable = mkEnableOption "extersia cache";

  imports = extersiaModules;

  config = {
    nix.settings = mkIf config.extersia.cache.enable {
      substituters = [ "https://extersia.cachix.org" ];
      trusted-public-keys = [ "extersia.cachix.org-1:ZHy9765xrhn4lDKGTzWWykHC+B091oTqNxClgc78MQU=" ];
    };
  };
}
