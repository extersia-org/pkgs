{
  lib,
  rustPlatform,
  fetchFromGitHub,
  polkit-stdin-agent,
  systemd,
  coreutils,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "run0-sudo-shim";
  version = "1.3.1-unstable-2026-06-15";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    rev = "6e397eebae4c7f3acb8eca080d1c56be5be19e44";
    hash = "sha256-K+nghy9uAIJQ6Ox9hc3U+utiPJMwskwhPorJ7y7ZZow=";
  };

  cargoHash = "sha256-ly2e2x1Z1XEXblGqWi+/r5q2FmvpekVfzGVGm+S1xio=";

  env = {
    POLKIT_STDIN_AGENT = lib.getExe polkit-stdin-agent;
    RUN0 = lib.getExe' systemd "run0";
    TRUE = lib.getExe' coreutils "true";
  };

  postInstall = ''
    ln -s $out/bin/run0-sudo-shim $out/bin/sudo
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "An imitation of sudo, using run0 internally";
    homepage = "https://github.com/LordGrimmauld/run0-sudo-shim";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "run0-sudo-shim";
    platforms = lib.platforms.linux;
  };
})
