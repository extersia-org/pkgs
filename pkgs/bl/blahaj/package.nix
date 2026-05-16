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
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "a69af3a2ebdba3e7d4a4327eae829bebba96a59b";
    hash = "sha256-uh0KCi/uYkvr6id582En0EWqsgTvSvisuCu/M/uMKs4=";
  };

  cargoHash = "sha256-iagcIsjFj2k0HBKAAi2n6YTkhUA9BLv4QxsCziYULBU=";

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
