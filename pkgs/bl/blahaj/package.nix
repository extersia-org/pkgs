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
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "f8ce5ade76822e7631b08afa6be8c6951ace3294";
    hash = "sha256-DpKfDDOsKZ7gpAODI51gAl2eHM9uUd6tS9f1O2MJ1f8=";
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
