{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.4.0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "09616c59d295cea35f2f96d5cbd27026f2228f6a";
    hash = "sha256-TGjAT3VDNTfXJr/0bBiTAjZuUViwb9dYWnNbFqz6Cv0=";
  };

  vendorHash = "sha256-QjOgdgBvKRNADBEQM/d/WzkUAfFPqr62+vcmKMFltYQ=";

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
