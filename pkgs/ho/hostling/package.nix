{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "0d826c6ed38ec9771b8143774e4b0641cdbc344d";
    hash = "sha256-jdzQ6C22awq6nxjAr0ijc0bsKFIP7V3b9z6v0moH6DQ=";
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
