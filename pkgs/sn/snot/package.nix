{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "f516a90123fd2db2224ddaa2b8376e32e72c6ed2";
    hash = "sha256-Tb1YsuXtkWTwvcMFiwe8qhB1YV9astiwa9z4eLgpbvs=";
  };

  vendorHash = "sha256-8rYVDpFHOM3BfIB4roTvk5pxG7W8lm/jKyHTDbqkv+M=";

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
