{
  lib,
  tailwindcss_4,
  buildGoLatestModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "piper";
  version = "0.2.1-unstable-2026-11-12";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "edf0963e5db13115d836c21144f02c0dc051ff5b";
    hash = "sha256-x9ah/+48j9ooSd1J2626BeRIHRnGSfCxMI9cD5pVdtg=";
  };

  vendorHash = "sha256-0CAKzBBARoHSqDv34Xx3Yek6r33Exhrhvn+FzGlby14=";

  nativeBuildInputs = [
    tailwindcss_4
  ];

  subPackages = [ "cmd" ];

  ldflags = [ "-s" ];

  env.CGO_ENABLED = 1;

  postBuild = ''
    cp -r ./pages/templates $out/
    cp -r ./pages/static $out/

    tailwindcss -i $out/static/base.css -o $out/static/main.css -m
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/piper
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Scrobbler for teal.fm";
    homepage = "https://github.com/teal-fm/piper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "piper";
  };
})
