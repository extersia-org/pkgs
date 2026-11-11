{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.5.0-unstable-2026-11-10";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "d71e2a3016106dfe9fb2807680fbb7f63897be88";
    hash = "sha256-vV86lhJTNvS1ViMmUQDTnxpgjNoPR/YBcibXZpss4IM=";
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
