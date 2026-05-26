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
    rev = "e5b57a6d47d9986685db799dd361c23695362ab4";
    hash = "sha256-Jl/aYMrmlkWnWt9HLOqdxdcuAAAChukIa8LvIh9fwQ0=";
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
