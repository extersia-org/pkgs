{
  lib,
  buildGoLatestModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "ad055bca8656c7883ac077935dec011b142dd96b";
    hash = "sha256-p3xD+yPS2PD+xLZycvS3AVaP32p+gsf47717B/iXfhE=";
  };

  vendorHash = "sha256-NIe0Cmo4j3A5B/N0jxRdyusu3iqRUJ0+PFjiP8j7D3k=";

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
