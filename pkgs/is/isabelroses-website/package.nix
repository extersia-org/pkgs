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
  version = "0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "3aa6cf0bbc08497e1d2cee11a92111734b979637";
    hash = "sha256-gt1ZHQVMuzoVTY840vK0jmQo8kJi1JQr61mkRcurC7Y=";
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
    hash = "sha256-bn0SPLHLsSF2pcjv0gb2GhnAGfMytIsTc8VZXW7imKo=";
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
