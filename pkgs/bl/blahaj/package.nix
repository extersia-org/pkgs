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
  version = "0-unstable-2026-06-01";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "28320623a107e333e93a2cba561e43df3bf3e6e9";
    hash = "sha256-N+FVzXghOCV1OJFmsmut2VaP8qj9ehal3vTqBXRxjHw=";
  };

  cargoHash = "sha256-aedz9Tj1irbiSFRlDB8ioA8OYAK6x5v0XbHR/WibylM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = finalAttrs.version;

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
