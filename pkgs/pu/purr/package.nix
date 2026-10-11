{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "purr";
  version = "1.4.1-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "65b037603065c9608a0c69e00784cfa7c387d650";
    hash = "sha256-A5GVn9ZkW/5aks3vXCmXNATDG40RX7F4NMhI5pZyarY=";
  };

  cargoHash = "sha256-+GkCMY+TNc0BqVG3OpGw2B2O9iD6RT3MFoQcZ1HX3GM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Utility commands for managing userstyles";
    homepage = "https://github.com/uncenter/purr";
    license = lib.licenses.mit;
    mainProgram = "purr";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
