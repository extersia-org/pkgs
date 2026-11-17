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
  spdx-license-list-data,
  stdenv,
  cacert,
  cursor-cli,
  grok-build,
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "t3code-server";
  version = "0.1.11-nightly.20261117.4814-unstable-2026-11-17";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pingdotgg";
    repo = "t3code";
    rev = "a191997bb183feeea35039d91c303d0764e6c4dd";
    hash = "sha256-xOW9u8q+ksl9BRR2wiTnA+bF2NRei21FLtTgWholkA0=";
  };

  postPatch = ''
    # This package serves the browser client, not the Electron desktop client.
    substituteInPlace apps/web/src/main.tsx \
      --replace-fail \
        'import { isElectron } from "./env";' \
        "" \
      --replace-fail \
        ${lib.escapeShellArg "    ? isElectron\n      ? import(\"./components/clerk/ElectronManagedAuthShell\")\n      : import(\"./components/clerk/BrowserManagedAuthShell\")"} \
        ${lib.escapeShellArg "    ? import(\"./components/clerk/BrowserManagedAuthShell\")"}

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

    mkdir -p .generated/third-party-licenses/spdx/v3.28.0
    cp ${spdx-license-list-data.json}/json/details/*.json \
      .generated/third-party-licenses/spdx/v3.28.0
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
    hash = "sha256-IkcGAo4w0aQJjvdWL3bMlDmUx37oRyGJYcr4yyMwAh4=";
  };

  buildPhase = ''
    runHook preBuild

    export pnpm_config_verify_deps_before_run=false
    node scripts/update-release-package-versions.ts ${
      lib.head (lib.splitString "-" finalAttrs.version)
      + "-nightly."
      + lib.last (lib.splitString "-unstable-" finalAttrs.version)
    }

    export npm_config_nodedir=${nodejs}
    pnpm rebuild --pending "''${pnpmInstallFlags[@]}" --filter '!@t3tools/monorepo'

    cp .env.example .env
    pnpm vp run --filter t3 build

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
          # tooling
          gitMinimal
          gh

          # slop machines
          opencode
          codex
          claude-code
          github-copilot-cli
          cursor-cli
          grok-build
        ]
      }

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=maria/redesign/6-workspace-panes"
        "--version-regex"
        "^v([0-9]+[.][0-9]+[.][0-9]+.*)$"
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
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = [ "x86_64-linux" ];
  };
})
