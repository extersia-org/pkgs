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
  version = "1.3.0-unstable-2026-06-09";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    rev = "5b38b36ae5936453dea8b0a9468d069b8ab6dcc2";
    hash = "sha256-hvShRy+l1GuaUkTNMtLd2rPdRSuxqlF4wycOvCmrerI=";
  };

  cargoHash = "sha256-P5a6AgCBR10skJyB/oQE/sfv54qqjDwpEmPDOOA3QPw=";

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
