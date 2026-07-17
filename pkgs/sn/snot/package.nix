{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "3924b38373de5b0c223fe1546f57c7a5ac67f46a";
    hash = "sha256-HfVy/maFoDuhXHQmVpBXze4AADt23yi/aB0oKxO9RPI=";
  };

  vendorHash = "sha256-GeoCWP8azDeQu+acSlmzjf0Adogq/WlbQirB2yma9Tk=";

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
    "-X github.com/isabelroses/snot/internal/xrpc.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ gitMinimal ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A tangled knot shim backed by a Forgejo instance";
    homepage = "https://github.com/isabelroses/snot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "snot";
  };
})
