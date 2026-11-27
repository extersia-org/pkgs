{
  lib,
  tailwindcss_4,
  buildGoLatestModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "piper";
  version = "0.2.3-unstable-2026-11-26";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "6721cd8405c98c2c7354b8bbef58ee4d74c7eb58";
    hash = "sha256-MJ8Ofj/+HxM4gW92W6Moi5yEYCOgcqNbAiQs9/Y+j9k=";
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
