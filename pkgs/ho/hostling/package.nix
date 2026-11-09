{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.5.0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "bb92bd0baebf74cff1f8e2cfa23bc5ba6f4ac65f";
    hash = "sha256-FCuPQlkodJA4SRdBPh2v7V1f25l5/tj9TJuw7zn/fRw=";
  };

  vendorHash = "sha256-L1E4vUMytZTzQ0Xz9U0Gzb9J6w2m1dEMVvHQARxPdqY=";

  excludedPackages = [ "frontend" ];

  prePatch = ''
    mkdir -p ./public/dist
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
