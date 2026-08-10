{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gtk3,
  glib,
  cairo,
  pango,
  harfbuzz,
  gdk-pixbuf,
  atk,
  libGL,
  libepoxy,
  openssl,
  sqlite,
  libgcrypt,
  libx11,
  libxcursor,
  libxinerama,
  libxrandr,
  libxi,
  libxext,
  libxfixes,
  lz4,
  libgpg-error,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cake-wallet";
  version = "6.3.0";

  src = fetchzip {
    url = "https://github.com/cake-tech/cake_wallet/releases/download/v6.3.2/Cake_Wallet_v${finalAttrs.version}_Linux.tar.xz";
    hash = "sha256-sWcPccC1ffN5x0fZ4ffUXJ0WYhW7EXv+Uj70TEPoSs4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    cairo
    pango
    harfbuzz
    gdk-pixbuf
    atk
    libx11
    libxcursor
    libxinerama
    libxrandr
    libxi
    libxext
    libxfixes
    libGL
    libepoxy
    openssl
    sqlite
    libgcrypt
    lz4
    libgpg-error
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cake-wallet";
      desktopName = "Cake Wallet";
      comment = "Secure cryptocurrency wallet";
      exec = "cake-wallet";
      icon = "cake-wallet";
      categories = [
        "Office"
        "Finance"
      ];
      type = "Application";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/cakewallet}
    cp -r * $out/opt/cakewallet/

    ln -s $out/opt/cakewallet/cake_wallet $out/bin/cake-wallet

    ln -s libsqlite3_flutter_libs_plugin.so $out/opt/cakewallet/lib/libsqlite3.so

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/opt/cakewallet/data/flutter_assets/assets/images/app_logo.png \
      $out/share/icons/hicolor/256x256/apps/cake-wallet.png

    runHook postInstall
  '';

  appendRunpaths = [ "${placeholder "out"}/opt/cakewallet/lib" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open-source cryptocurrency wallet";
    homepage = "https://cakewallet.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cake-wallet";
  };
})
