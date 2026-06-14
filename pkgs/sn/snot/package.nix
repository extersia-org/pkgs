{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "0b55b9865c5902c2c13020fad7f6f6ec46a4cf32";
    hash = "sha256-yKUe/2NsdmRY38qdx0v4JMKTH0yn+nVuEGTandXUOKE=";
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
