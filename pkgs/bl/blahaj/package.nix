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
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "cf5fbc97b6c27e286b2157236d6706b54c6075de";
    hash = "sha256-vFc4T+3YmHYTYIm8MsyeY79RYrvAQ61iQWCxS85fNuE=";
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
