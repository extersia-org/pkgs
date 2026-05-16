{
  lib,
  buildGoModule,
  fetchFromTangled,
}:
buildGoModule (finalAttrs: {
  pname = "quoteit";
  version = "0.0.1";

  src = fetchFromTangled {
    did = "did:plc:tgh3zbclfz53khwi4mmg2ax6";
    rev = "718a32a81400101f6a3a85d1fc00711a2eca26a5";
    hash = "sha256-ba1G3ESNFDgYIUST5QclDjropOrSqusPxF5teGHtB6M=";
  };

  vendorHash = "sha256-bnPYgnoGEUl5BfxjSb2p6Ywe4RRp/UwsUCdA1HqBS7M=";

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
