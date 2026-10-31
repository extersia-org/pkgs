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
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "9e7eb6e1c2f468e0bd4444fe636e180b60125a5e";
    hash = "sha256-a60H6HyjOuJGal3pugEgcuTlVuA/LrkBdQyCFm/qb6M=";
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
    hash = "sha256-5yAK6lT3qwPAhGrF9SRrM9X+d++3Ra/63Djk5QvAcVk=";
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
