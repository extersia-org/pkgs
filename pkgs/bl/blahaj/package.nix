{
  lib,
  rustPlatform,
  openssl,
  sqlite,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blahaj";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "298388ffc15019ca94340a987fb9459e808329a7";
    hash = "sha256-0KsDwqjWJaom5aw9ysaFlkLOeicN8/U+06QlZsEkcoA=";
  };

  cargoHash = "sha256-zBw5PC16WyqQXAjhibwGeg3cBW7qRbnDWgVQmm9swS0=";

  buildInputs = [
    openssl
    sqlite
  ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = finalAttrs.src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "the resident discord bot of hell :3";
    homepage = "https://github.com/isabelroses/blahaj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "blahaj";
  };
})
