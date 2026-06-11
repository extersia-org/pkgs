{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    extersia.url = "path:../.";

    nuscht-search = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      extersia,
      nuscht-search,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system: {
        extersia-docs = nixpkgs.legacyPackages.${system}.callPackage ./package.nix {
          nuscht-search = nuscht-search.packages.${system};
          extpkgs = extersia.legacyPackages.${system};
        };
      });
    };
}
