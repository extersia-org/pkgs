let
  lockfile = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lockfile.nodes.nixpkgs.locked;
  nixpkgs' = fetchTarball {
    inherit (node) url;
    sha256 = node.narHash;
  };
in
{
  nixpkgs ? nixpkgs',
  pkgs ? import nixpkgs {
    inherit system;
    overlays = [ ];
    config.allowUnfree = true;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  inherit (builtins) readDir;
  inherit (lib) mapAttrs mergeAttrsList mapAttrsToList;

  baseDirectory = ./pkgs;

  # logic based on
  # https://github.com/NixOS/nixpkgs/blob/7d7db0123ed366fe21d80ea7fec3a98746770013/pkgs/top-level/by-name-overlay.nix
  packagesForShard =
    shard: _:
    mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
      readDir (baseDirectory + "/${shard}")
    );

  packagesFiles = mergeAttrsList (mapAttrsToList packagesForShard (readDir baseDirectory));

  mkPackages =
    pkgs: lib.makeScope pkgs.newScope (self: mapAttrs (_: lib.flip self.callPackage { }) packagesFiles);

  packages = mkPackages pkgs;

  mkModule =
    {
      name ? "default",
      class,
      file,
    }:
    {
      _class = class;
      _file = "${toString ./.}#${class}Modules.${name}";
      imports = [ file ];

      config._module.args = {
        extpkgs = packages;
      };
    };
in
{
  inherit packages;

  nixosModules.default = mkModule {
    class = "nixos";
    file = ./modules/nixos;
  };

  darwinModules.default = mkModule {
    class = "darwin";
    file = ./modules/darwin;
  };

  homeModules.default = mkModule {
    class = "homeManager";
    file = ./modules/home-manager;
  };
}
