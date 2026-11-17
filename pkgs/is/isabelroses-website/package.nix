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
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "website";
    rev = "9376dbcdeef8c4f9ce90706a906c74262b288852";
    hash = "sha256-RWWXTtpc0Du1n5tqshGjRZBX9xAQVh/4kj2sRl9yMn8=";
  };

  nativeBuildInputs = [
    just
    pnpm
    nodejs-slim
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Fdo7S6SW/9fDXv9yAibQ2Ti6ZFREINVElPZ2YP7Wdj4=";
    fetcherVersion = 5;
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
