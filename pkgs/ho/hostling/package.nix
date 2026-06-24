{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-06-21";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "14616b43c25fc0ed9add935d0f11bd41c847c242";
    hash = "sha256-n2DH+2NLerfAziBbznYotSl2BwPLwIW1qivIwqWjK/4=";
  };

  vendorHash = "sha256-9iRUJ8YzKscg++Kgu8KYKGsxzZ1aYhzBZCFcrfZodts=";

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
