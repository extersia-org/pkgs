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
  version = "1.2.0-unstable-2026-06-01";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    rev = "ae23e03851a4536ac5dd06dd203391fddd72ab13";
    hash = "sha256-uaGJmGr+qHTlC2+jlVPzLF1Qf0Vid8DmxmYtxuG6WH4=";
  };

  cargoHash = "sha256-9t4VsrBnA0JjzdY3Pwv3ynlmdP/rtAQa3HxzqnL/5Xs=";

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
  };
})
