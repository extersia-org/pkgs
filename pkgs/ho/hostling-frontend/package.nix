{
  lib,
  nodejs,
  stdenv,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hostling-frontend";
  version = "0.5.0-unstable-2026-11-18";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "a0f70a7cca9fe1c925af76e5d9419924d467bb0b";
    hash = "sha256-etITqW0vIqH3G+3mx3ucSkL0T6MwNI3pJNTupqM0Hpk=";
  };

  sourceRoot = "${finalAttrs.src.name}/frontend";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-wdNtI7JTEttYx0CY5IYYLirhl/UAGn4vlaFdSdcr4+Q=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build --outDir=dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist "$out"

    runHook postInstall
  '';

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
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
