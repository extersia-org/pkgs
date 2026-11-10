{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.5.0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "d96ab3d3a7bee7a9f80558e2ad657c5aaa6e8ff8";
    hash = "sha256-46IwGFkslcLFGJB8FUaQ1XNZWmOzgj/fQrVc4/fBTCE=";
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
