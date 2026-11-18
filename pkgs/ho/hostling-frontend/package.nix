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
  version = "0.5.0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "b00e9c394ac8ed9a67046b9f7da6dda0a8bc7b93";
    hash = "sha256-lgCZLoEKVzpxiOF1oYNbq1kTXIo5AU/TUD2GoQFpsd8=";
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
    hash = "sha256-6FIMGx9R/cdr6QvaYg0NFApwvrgulQ3xP/TFLC0qysc=";
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
