{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blahaj";
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "454773e264c50d9dc1c98fcd75154d4d8d32136d";
    hash = "sha256-un42VtJB1GE9wHg2L4RetBHQO0lTifuxoodCSkpsaHw=";
  };

  cargoHash = "sha256-aedz9Tj1irbiSFRlDB8ioA8OYAK6x5v0XbHR/WibylM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = finalAttrs.src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "the resident discord bot of hell :3";
    homepage = "https://github.com/isabelroses/blahaj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "blahaj";
  };
})
