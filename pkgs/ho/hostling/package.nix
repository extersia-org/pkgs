{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "5842955cb7e186605532abd9004ea40c02b606cf";
    hash = "sha256-tWbdh9ONP8V9J6yKAZ+4WITeRnZ08QpkwyhOy46iz8U=";
  };

  vendorHash = "sha256-wsZHXMom1C5d624nzyPorBqC5lKBtarN1copNOy7uDI=";

  prePatch = ''
    cp -r ${hostling-frontend} ./public/dist
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
