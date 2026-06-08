{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuigreet";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "tuigreet";
    tag = finalAttrs.version;
    hash = "sha256-jeelrp9r/V8540qKoCofD8wz/w/qBcubs72HkremhME=";
  };

  cargoHash = "sha256-B5Qxwv8jdpGJwXTEm5c12kvb6fri7H1AL2w640xQXVQ=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postInstall = ''
    scdoc < contrib/man/tuigreet-1.scd > tuigreet.1
    installManPage tuigreet.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/NotAShelf/tuigreet";
    changelog = "https://github.com/NotAShelf/tuigreet/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.isabelroses ];
    platforms = lib.platforms.linux;
    mainProgram = "tuigreet";
  };
})
