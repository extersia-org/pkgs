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
  version = "0.5.0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "4d19f890ea1287a32a6ff0bfe6e83ec616e020bd";
    hash = "sha256-9F0wgLvWOtw2oe7nmOdwnkc1uziHDgu0mduU/bFLkW8=";
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
    hash = "sha256-d/91ATnbtXS592Sl2ElH/MI46gmF0Q+wLMcID3s99yA=";
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
