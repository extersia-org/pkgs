{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.4.0-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "6c9e45d1fa2e67bed9182ae4e067bcab3633e8e5";
    hash = "sha256-8eHUskfsdymVTYt5V/f75vKsvmuZz/CNGqbthSQrHow=";
  };

  vendorHash = "sha256-NP363PtrTcI1EubIBJEoMCTkHCGsNRM8fY2fgwSlz5s=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A RSS feed reader for the terminal";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "izrss";
  };
})
