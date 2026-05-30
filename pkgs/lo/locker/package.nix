{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "2.0.0-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "e58380f9e5bb3c567ed39f2b63ef8b29e35074c6";
    hash = "sha256-fuejSgmH9Ozneh2aLHx4Pa40Z7OfhrKUF756dwixQmo=";
  };

  cargoHash = "sha256-kR6hdQ/4CNH9xcnce5jpawgbywYPRWBCG/9eww+kO3c=";

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
