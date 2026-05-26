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
    rev = "0a0b4bacbe7e560e1bf63d444b9ec87c2ba522d9";
    hash = "sha256-G/ItunIJn6ic445x+heSiotgrDiz7HEW/xi7KP8saYI=";
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
