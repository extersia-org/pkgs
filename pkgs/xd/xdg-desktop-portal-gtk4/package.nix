{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-gtk4";
  version = "1.6.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JohnRTitor";
    repo = "xdg-desktop-portal-gtk4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F15UsZx/mqcHAxVbDkpYpDOqTxKvrUNGXY/D8FzyWcQ=";
  };

  cargoHash = "sha256-ZbYZCshfrj60tPt0HEMMyp4fO7ZXCWiHaCBs69ZPORA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK4 implementation of xdg-desktop-portal in Rust";
    homepage = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "xdg-desktop-portal-gtk4";
  };
})
