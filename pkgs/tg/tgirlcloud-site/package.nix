{
  lib,
  pnpm,
  stdenvNoCC,
  nodejs-slim,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tgirlcloud-site";
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "57f585e43fcc65e8180679a21014d56c0abe8d1c";
    hash = "sha256-1pwog8QEY9hSFamJUtVXitcVvNuDv4h8ic6Br5fMUBQ=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-XkJddZxn4k8B8Mot2Rwwn6K4RNF2mnIzpqemUQTD19I=";
    fetcherVersion = 4;
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "The source code tgirl.cloud site";
    homepage = "https://github.com/tgirlcloud/site";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
