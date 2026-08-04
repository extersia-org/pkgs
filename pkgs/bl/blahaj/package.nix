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
  version = "0-unstable-2026-08-04";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "16c19e008b981a1eefaa1e7d5dfa971908560416";
    hash = "sha256-/C1l9sNUKwQqpZq5v7rC5eeQJsBInRi3CBLu2rOOZ5E=";
  };

  cargoHash = "sha256-HlVbfa8OrRmZAtCSxvwChB7BXrWoBm98crM60eQctMw=";

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
