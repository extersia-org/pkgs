{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "43c98fc962ac1cdbc117d0060c7880db202873e7";
    hash = "sha256-pgoz3I5glTHC5dPNaf6pxYIt2/yzzQ9LoJoJS4Diksc=";
  };

  vendorHash = "sha256-CTlUyvDemiKHDhM6zsGInlcFNl49W2C5mXP9pZORQLc=";

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
