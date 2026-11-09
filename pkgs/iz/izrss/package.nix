{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.5.2-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "343f71e4ca9fe2b77a4d756dda8ff66c079ec0d1";
    hash = "sha256-WVbuT33EHz/wNyOLguaV8vgtSstEKm35DkGEISldz+s=";
  };

  vendorHash = "sha256-PVrdIpyNF9FwnG1jmBQPdE/CHxGZGUSbNTPeo7uWvvw=";

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
