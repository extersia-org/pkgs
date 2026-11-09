{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-track";
  version = "0.6.0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "ec171f87bd6e557cb9cc5a69306bc102e4997f4a";
    hash = "sha256-K9wmNRKa2aeM/Q5IkMPQa2LNcqN3RB/GnPq4ApmnjlU=";
  };

  cargoHash = "sha256-zvK+/924I8iawpKRSiDhwyoYet/qXpL0Z1lUAYk41TQ=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Track where Nixpkgs pull requests have reached";
    homepage = "https://github.com/uncenter/nixpkgs-track";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-track";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
