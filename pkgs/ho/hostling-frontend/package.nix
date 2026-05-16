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
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "d134b9fd6e3caf1733fdbc1db42448dbff3cb099";
    hash = "sha256-YrlXd3mVg11hVJdkQEBzX7wolpMp1aZNdkHKREEkLs8=";
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
    hash = "sha256-MMFcvD1maLgFnn2Lw78IpqZrwc8zoVt+pxZ7Ohlztis=";
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
