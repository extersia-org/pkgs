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
  version = "0.5.0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "bb92bd0baebf74cff1f8e2cfa23bc5ba6f4ac65f";
    hash = "sha256-FCuPQlkodJA4SRdBPh2v7V1f25l5/tj9TJuw7zn/fRw=";
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
    fetcherVersion = 4;
    hash = "sha256-FMnSdYeoCJcXGI25wHr2f1g+DWPASK07ySVFJDsuEB0=";
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
