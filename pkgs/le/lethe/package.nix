{
  lib,
  rustPlatform,
  pkg-config,
  sqlite,
  zstd,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lethe";
  version = "0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "e1589f1ebef0ba08b916038512481bf2468b9d80";
    hash = "sha256-qj2okJoiVYK0SVucTKBwxjX9+p1bfZ6/qjofJHCFJIc=";
  };

  cargoHash = "sha256-6L+y6qxRneVjuAtPAMxcC+oiaVn0xi4IiqmX+EzUUFw=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    sqlite
    zstd
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lethe \
      --bash <($out/bin/lethe completions bash) \
      --fish <($out/bin/lethe completions fish) \
      --zsh <($out/bin/lethe completions zsh)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://tangled.org/isabelroses.com/lethe";
    description = "Never forget your NixOS deployments";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lethe";
  };
}
