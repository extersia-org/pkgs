{
  lib,
  rustPlatform,
  pkg-config,
  sqlite,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lethe";
  version = "0-unstable-2026-11-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "0398ae4ceeec10bd8f6ec7877d0bbd77100dc515";
    hash = "sha256-aSEq43SfmZcEV43Sp/CxTZg1zJ48H4qBb6Hh+iIBUcs=";
  };

  cargoHash = "sha256-bzleEKThPGyUp76awxSLhDreeZfQlb2RLlaKgnVODhA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ sqlite ];

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
