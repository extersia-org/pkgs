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
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JohnRTitor";
    repo = "xdg-desktop-portal-gtk4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wl9ZHxN8QzYkmPjn99/A3dGTQWv8YtcF48Y9pamnKUI=";
  };

  cargoHash = "sha256-n7ROoP7L6ebiEUv3e8cwO4F6RLhuX3tVvnYqwcE2XG0=";

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
    # gdk4-wayland and gdk4-x11 require the GTK4 backends, which nixpkgs does
    # not build on Darwin.
    platforms = lib.platforms.linux;
  };
})
