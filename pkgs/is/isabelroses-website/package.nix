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
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "249e852e9ef8ff0f4998a43dd7624cd9fbb73c42";
    hash = "sha256-5TZIP9/CCI5DVy8doRwtWc0gmvsZMOtxUPRDAJ/6cCU=";
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
    hash = "sha256-foBcCf/ZRNapmzp1r5RmC56vLkIsTUlHwrtOJVcLMY0=";
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
