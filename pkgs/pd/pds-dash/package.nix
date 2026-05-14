{
  lib,
  pnpm,
  stdenvNoCC,
  makeWrapper,
  nodejs-slim,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pds-dash";
  version = "0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "pds-dash";
    rev = "5104c043a275f2c8f4a71a21172897ba3c13b343";
    hash = "sha256-QjHS/C/PZR8OyvL5r2/c2LETkBfZ8a8C9NR4eVEZ8UQ=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    makeWrapper
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PTtstU6WzjdoyPjBAAnZR5UPbmMM7zV10O3s4/cQ274=";
    fetcherVersion = 3;
  };

  env.ASTRO_TELEMETRY_DISABLED = 1;

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r node_modules $out/node_modules
    cp -r dist/* $out

    makeWrapper ${nodejs-slim}/bin/node $out/bin/pds-dash \
      --add-flags "$out/server/entry.mjs"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "pds dashboard";
    homepage = "https://github.com/tgirlcloud/pds-dash";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds-dash";
    platforms = lib.platforms.all;
  };
})
