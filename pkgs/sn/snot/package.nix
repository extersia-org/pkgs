{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "816130c3c6ef489f77ccb5aba0409bb404ae93d9";
    hash = "sha256-Mh8Q7Nb9BtDCCnSROseOq7iAAGUvwMrscE4sbmIQcxk=";
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
