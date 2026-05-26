{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "a816810580bc2fd0ed84a1e2b5a79ae1db6385af";
    hash = "sha256-ht07dQVq7eRz2wI/OTUfNqS09wOUrnQHLSHdb/sNVSs=";
  };

  vendorHash = "sha256-ZLozZWXhbqHMGslNFgA0YYGy0YvxD124A4ONSmbU49c=";

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
