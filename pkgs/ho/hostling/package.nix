{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0-unstable-2026-05-08";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "cb47bb16c76c8897de7b9f9d95a0447968be71d5";
    hash = "sha256-bldOjxO/cWdiv211MCBS2Cg0nINVg3Qy2EDOZV1+xfk=";
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
