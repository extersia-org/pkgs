{
  lib,
  pnpm,
  just,
  nodejs-slim,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelroses-website";
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "8bb2944b9ef6131f73cb6555a382a3b93c0169a1";
    hash = "sha256-Q4K+Rp2yzeH4RvEwmqpPzHBtXFSMajmswl99Bzu6j4w=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-ocnd0c7s96kY00QrIN4Z/QaBaYndgurv5etFUOaN/WY=";
  };

  dontUseJustCheck = true;

  env.ASTRO_TELEMETRY_DISABLED = 1;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "isabelroses.com";
    homepage = "https://isabelroses.com/";
    license = with lib.licenses; [
      mit
      cc-by-nc-sa-40
    ];
    mainProgram = "isabelroses-website";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
