{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.4.0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "63ddc784b4335f060046362e477ee4968a078220";
    hash = "sha256-Naj2tyWiTpuhxdd5VUi7B93KJK0hWw09Ytb7cuLFLP4=";
  };

  vendorHash = "sha256-PMrSfUe6hrnVC35dx4dTkTouFRblRNPTWpv2NM5nbgY=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A RSS feed reader for the terminal";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "izrss";
  };
})
