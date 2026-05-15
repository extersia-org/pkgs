{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "939a4e136261b3aad829b5d22f17265c6011a7a6";
    hash = "sha256-5X5Sf3PyjsF4Egk/6PrG2E8fVzsZRAyoz+T83kIY5mw=";
  };

  vendorHash = "sha256-erwYPfFuqv0YuLO1WZtRhk0lTmkx764mfWENSN7yEyE=";

  prePatch = ''
    cp -r ${hostling-frontend} ./public/dist
  '';

  ldflags = [
    "-s"
    "-w"
  ];

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
