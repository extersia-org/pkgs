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
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "8115fb8c559f1fe3166fd534306e1e48e86b0d72";
    hash = "sha256-8xReux/WhJ8bemeUpcDECS5OrTtCWvBsnHrAwSCXJpQ=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+IolgGj/3OiFaYEeIbhW2D0lUdS9PYTnPZSbge1MqQY=";
    fetcherVersion = 3;
  };

  dontUseJustInstall = true;
  dontUseJustCheck = true;

  env.ASTRO_TELEMETRY_DISABLED = 1;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r dist/* "$out"

    runHook postInstall
  '';

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
