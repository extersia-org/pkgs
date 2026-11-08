{
  lib,
  rustPlatform,
  openssl,
  sqlite,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blahaj";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "b9fd8248e06eb9f9558bff33ba9fbd5b3d92bca2";
    hash = "sha256-IH49OEv7Kxe+cWb5rT4jgSZKjASYqq/dbD2SDQKfswM=";
  };

  cargoHash = "sha256-LmOcGPpLi8yBWW5OxmwiyxdBfePSkg2K0OZFynqmhqQ=";

  buildInputs = [
    openssl
    sqlite
  ];
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
