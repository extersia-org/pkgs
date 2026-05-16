{
  lib,
  buildGoModule,
  fetchFromTangled,
}:
buildGoModule (finalAttrs: {
  pname = "quoteit";
  version = "0.0.2";

  src = fetchFromTangled {
    did = "did:plc:tgh3zbclfz53khwi4mmg2ax6";
    rev = "effa50337ce46a99f696a3267c50f7e6cf33583c";
    hash = "sha256-m4O2x9A3zewaj2ykhHCKvzx3N8Up7b29fB2p4NlATGM=";
  };

  vendorHash = "sha256-kgKUSTPEntQtYtXMpbk1Yth9X2xmAZCf/xhOVntofoA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "REST API for collecting and serving quotes";
    homepage = "https://github.com/isabelroses/quoteit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "quoteit";
  };
})
