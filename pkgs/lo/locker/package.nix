{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "4.0.1-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "1a3f4385596a2e6827c87d73978324cb34c270fa";
    hash = "sha256-rVW2OcRG2h5G46UdRLYeZ5A0Gmca2fj5rRbZzMeDqqc=";
  };

  cargoHash = "sha256-gfhOOgZ8wkqbcghcCGCBMtImLfZazR2Dg/FgnjbofAg=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A linter for your flake.lock file";
    homepage = "https://github.com/isabelroses/locker-lint";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "locker";
  };
})
