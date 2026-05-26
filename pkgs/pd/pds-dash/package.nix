{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2026-05-26";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "158d51cf6dd96ecf653f442eb870d07c0ffd2d14";
    hash = "sha256-5bdliMSiYEiXMiS8K1nOAYK4treniTNEzW9LJShVI4k=";
  };

  cargoHash = "sha256-nt8QLciQyXvvFI3UpcKEkwGSZe7BiabiSBtpNo43m3M=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "pds dashboard";
    homepage = "https://github.com/tgirlcloud/pds-dash";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds-dash";
    platforms = lib.platforms.all;
  };
})
