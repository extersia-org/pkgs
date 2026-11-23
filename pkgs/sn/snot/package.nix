{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "7029381b376810b7b479f77414551ad76a85a0cd";
    hash = "sha256-RDls1vcejtphiq1SgvG17/GTX1rWeZzz+By2Ar2UfYk=";
  };

  vendorHash = "sha256-UJlHw14n3XH5nM6Cgp/s5mAgYHEqXhhMVYEhVJ408kY=";

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
