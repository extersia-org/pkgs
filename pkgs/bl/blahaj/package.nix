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
    rev = "3724115ff3502a2a5d56cb83aa7d42f75b300343";
    hash = "sha256-iTPTXnhiiUWDsJiiPV8a9RS4ZNkTh60ulbZnC5devhI=";
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
