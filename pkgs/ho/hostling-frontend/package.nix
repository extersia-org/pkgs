{
  lib,
  nodejs,
  stdenv,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hostling-frontend";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "f296e0218822e376b62ae0b7181d2abb9189377e";
    hash = "sha256-D10Etw4DLCUHF1HmPv2rYhB0MqQLoQ42CoRRshYIN2U=";
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
    fetcherVersion = 3;
    hash = "sha256-pTLkT0douxPJ3U6hLungQChg3IQ1w1r1+M72JI8XcsI=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build --outDir=$out

    runHook postBuild
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
