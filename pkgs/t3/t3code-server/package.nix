{
  claude-code,
  codex,
  fetchFromGitHub,
  fetchPnpmDeps,
  gh,
  gitMinimal,
  github-copilot-cli,
  lib,
  makeBinaryWrapper,
  node-gyp,
  nodejs_26,
  nix-update-script,
  opencode,
  pnpm_12,
  pnpmConfigHook,
  python3,
  rustPlatform,
  stdenv,
  cacert,
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "t3code-server";
  version = "0.1.9";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pingdotgg";
    repo = "t3code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3i5o9gs/nYx0vxyn2ukYtLEA21UZZdX0x4ebgxY8bhI=";
  };

  postPatch = ''
    substituteInPlace apps/server/src/preview/PreviewBrowser.ts \
      --replace-fail \
        '  return PreviewBrowser.of({ executable, installed });' \
        '  const override = process.env.T3CODE_BROWSER_EXECUTABLE;
      if (override) {
        return PreviewBrowser.of({
          executable: Effect.succeed(override),
          installed: Effect.succeed(Option.some(override)),
        });
      }
      return PreviewBrowser.of({ executable, installed });'

  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    node-gyp
    nodejs
    python3
    pnpm
    pnpmConfigHook
    cacert
  ];

  pnpmWorkspaces = [
    "@t3tools/monorepo"
    "t3..."
    "@t3tools/web..."
    "@t3tools/scripts..."
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit pnpm;
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 5;
    hash = "sha256-mprGkCoSnB2MM5xE6HdbVtBFJ+qtBmzZTfWTcE5AcjM=";
  };

  buildPhase = ''
    runHook preBuild

    export pnpm_config_verify_deps_before_run=false
    node scripts/update-release-package-versions.ts ${finalAttrs.version}

    export npm_config_nodedir=${nodejs}
    pnpm rebuild --pending "''${pnpmInstallFlags[@]}" --filter '!@t3tools/monorepo'

    cp .env.example .env
    pnpm --filter t3 run build:bundle

    runHook postBuild
  '';

  dontPatchELF = true;
  noAuditTmpdir = true;

  installPhase = ''
    runHook preInstall

    dest=$out/libexec/t3-server
    mkdir -p $dest/apps/server $dest/node_modules/.pnpm
    cp -r --no-preserve=mode apps/server/{package.json,node_modules,dist} $dest/apps/server
    pnpm --filter t3 list --prod --depth Infinity --parseable \
      | grep -o 'node_modules/\.pnpm/[^/]*' | sort -u \
      | while read -r entry; do
          case "$entry" in
            node_modules/.pnpm/knip@*|node_modules/.pnpm/@effect+tsgo@*) continue ;;
          esac
          [ -e "$entry" ] || continue
          cp -r --no-preserve=mode "$entry" $dest/node_modules/.pnpm/
        done
    find $dest \( -name '*.map' -o -name '*.py' \) -delete
    find $dest/node_modules/.pnpm \
      \( -path '*/node_modules/node-pty/prebuilds/win32-*' \
         -o -path '*/node_modules/node-pty/prebuilds/darwin-*' \
         -o -path '*/node_modules/node-pty/prebuilds/linux-arm64*' \
         -o -path '*/node_modules/effect/src' \
         -o -path '*/node_modules/effect/src/*' \) -delete
    find $dest -xtype l -delete

    makeWrapper ${lib.getExe nodejs} $out/bin/t3 \
      --add-flags $dest/apps/server/dist/bin.mjs \
      --set-default T3CODE_RESOURCE_MONITOR_PATH ${lib.getExe finalAttrs.passthru.resourceMonitor} \
      --prefix PATH : ${
        lib.makeBinPath [
          claude-code
          github-copilot-cli
          codex
          gitMinimal
          gh
          opencode
        ]
      }

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^v([0-9]+[.][0-9]+[.][0-9]+)$"
        "--subpackage"
        "resourceMonitor"
      ];
    };

    resourceMonitor = rustPlatform.buildRustPackage {
      pname = "${finalAttrs.pname}-resource-monitor";
      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs.src.name}/native/resource-monitor";
      cargoHash = "sha256-5cmG2daM1bVOA23gjjoalbx0fEL1hmqV6WZov0sUZp8=";
      meta.mainProgram = "t3-resource-monitor";
    };
  };

  meta = {
    description = "T3 Code headless server";
    homepage = "https://t3.codes";
    changelog = "https://github.com/pingdotgg/t3code/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = [ "x86_64-linux" ];
  };
})
