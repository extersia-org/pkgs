{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.5.0-unstable-2026-11-19";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "3dd895d21a8b78dcf1daeeeb5e52f85ccd8c6a54";
    hash = "sha256-ryOrkN/WJls0ia+mAGMKBI0OTsoq3unMYAqwM8sJVBM=";
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
