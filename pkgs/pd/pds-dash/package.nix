{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "88eb569cd4dc5c8742de931bac4d73606e5197ab";
    hash = "sha256-dD3t1cykCj5rAmoX+RePKMiGlrqoO+6Md8hshcqxsEM=";
  };

  cargoHash = "sha256-i2gyy6DveaG1CJLvd9nrxpPSTKT+9a1IoDQ2zNXi65A=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "pds dashboard";
    homepage = "https://github.com/tgirlcloud/pds-dash";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds-dash";
    platforms = lib.platforms.all;
  };
})
