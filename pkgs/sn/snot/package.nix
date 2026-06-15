{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "c7a75953baa13a11eea000e10872b3a081f6728b";
    hash = "sha256-vN85kdjkaN1o+hWVlN3pmhSxGepMlzPrHyepbTLoAyc=";
  };

  vendorHash = "sha256-b/HJO+zvxFZHr+Z6TEw92VLjaTntaEVhlwFwSa0mLz4=";

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
