{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-07-11";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "ce23cb231d895ea4076ee66e1405288a76ad1707";
    hash = "sha256-22YKbwM0D+AezX2LMPD7GZfphj3n6cvT01NIU0y+nfE=";
  };

  vendorHash = "sha256-U2thlCZxeLXqS8etLr30npMVpur5caIAc0our310ISE=";

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
