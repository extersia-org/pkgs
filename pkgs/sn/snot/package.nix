{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-06-18";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "6c86c74b6bd6d6f963546685e690917f151ec424";
    hash = "sha256-wrZlYlAl/tYGK09qEA7EDnHCqI2x8IE6BCyOHT3eKF0=";
  };

  vendorHash = "sha256-c2wTNpQUQrvm5eSNdzXceCGOnrnEjUdtzCWVX+WJJs8=";

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
