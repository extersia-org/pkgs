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
    rev = "a6fcc88cf5190306bad00a292966e5c398398855";
    hash = "sha256-PG1XIBhwc4e1HI0OTkxib3OOfKIGHo7hWHRT+lxY7l8=";
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
