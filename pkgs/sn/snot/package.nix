{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "snot";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "snot";
    rev = "d65f80582cd46c46b7fe9b042bc20b54f9389f02";
    hash = "sha256-YNWnwyljFYSuLv5T4yzjVDV5IBjLFGvwqzfLLPD/Wmo=";
  };

  vendorHash = "sha256-DH7PTmkZHjl8VJ4l/2zGg5qYq3+LqI4SvrE4nbNU9yo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X github.com/isabelroses/snot/internal/xrpc.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ gitMinimal ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A tangled knot shim backed by a Forgejo instance";
    homepage = "https://github.com/isabelroses/snot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "snot";
  };
})
