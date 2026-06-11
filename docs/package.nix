{
  pkgs,
  nuscht-search,
  extpkgs,
  ...
}:
let
  urlPrefix = "https://github.com/extersia/pkgs/blob/main/";
in
nuscht-search.mkMultiSearch {
  title = "extersia Option Search";
  baseHref = "/";

  scopes = [
    {
      name = "NixOS modules";
      modules = [
        ../modules/nixos
        { _module.args = { inherit pkgs extpkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "darwin modules";
      modules = [
        ../modules/darwin
        { _module.args = { inherit pkgs extpkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "home-manager modules";
      modules = [
        ../modules/home-manager
        { _module.args = { inherit pkgs extpkgs; }; }
      ];
      inherit urlPrefix;
    }
  ];
}
