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
  version = "0.6.0-unstable-2026-10-11";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    rev = "c337007f63e02a69a669e97896a0517145b02a2a";
    hash = "sha256-VDJ+k004uCwPXxADTjeS2vgGEUH8ed4Xv0kiDR2oX4c=";
  };

  cargoHash = "sha256-lnv0nCyb2+7Xl+qAAeaHdbk4XOGdq4FINxPOIPchDhg=";

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
