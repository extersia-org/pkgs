{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.4.0-unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "5299306023741fa240fc0abd0fc551dea7a48c4b";
    hash = "sha256-WZy1lbkHEQ58mgDceIVf4c9ZvFaVDQAvavpY6vhfM+8=";
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
