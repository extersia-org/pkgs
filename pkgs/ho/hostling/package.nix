{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.5.0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "de92eb56a201ec6969ea3aa47b96ecb19d899d93";
    hash = "sha256-myRSBiR3RI7FNNGdo4I3WQ6c9tRjKQVHWSPd1lrb33s=";
  };

  vendorHash = "sha256-50DeuEzupoj2/gxY/Fvg2ms/vpM/y5TWWS2T+LMsHwk=";

  excludedPackages = [ "frontend" ];

  prePatch = ''
    mkdir -p ./public/dist
    cp -r ${hostling-frontend}/. ./public/dist/
  '';

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Simple file hosting service";
    homepage = "https://github.com/BatteredBunny/hostling";
    license = lib.licenses.mit;
    mainProgram = "hostling";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
