{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lix-diff";
  version = "1.5.1-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-diff";
    rev = "39581f49b0e33455a60fee583ce4710e62d2716e";
    hash = "sha256-mURA7fZ9RAhVtOx+gnEeJI48tyvi+zbKE+xUs5UMPY4=";
  };

  cargoHash = "sha256-yOVJjn/DaHDsBeSMKJ0bmav+I5JLa9HqII5RKFpc5Hw=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "";
    description = "generation diffing tool for Lix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
}
