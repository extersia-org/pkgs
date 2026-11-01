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
  version = "0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "f84e984c188073c8e5636cd7c28d4e2469fd8692";
    hash = "sha256-UkxtJhj89ilpKieN6CGTCugK5Um/v632dF2sba3folc=";
  };

  cargoHash = "sha256-zBw5PC16WyqQXAjhibwGeg3cBW7qRbnDWgVQmm9swS0=";

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
