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
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "6b9244c658c10bc99a0568136db52906b44a8da8";
    hash = "sha256-zsnJoKyYFeAkWUo15BOVT3s2JvNkRKPjCTZPbU37iDY=";
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
