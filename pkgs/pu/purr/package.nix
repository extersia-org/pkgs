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
  version = "1.5.0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "999f5544c3d88be5cd336a1723a83bb5fcb8788c";
    hash = "sha256-HHDzneElnptE9IbGHHwWrhXYfQuDbZ3q9hRSpbJ6JTk=";
  };

  cargoHash = "sha256-9xy5FkR35S2l/6PVTdNJ/uALy4uVXX88zYdgtcURHHI=";

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
