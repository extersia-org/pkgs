{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "f296e0218822e376b62ae0b7181d2abb9189377e";
    hash = "sha256-D10Etw4DLCUHF1HmPv2rYhB0MqQLoQ42CoRRshYIN2U=";
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
