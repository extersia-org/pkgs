{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "lethe";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "796deb2216ceee76a776af23f5e2534f769d459b";
    hash = "sha256-Px/x5UQKRGjg28DP9A3RhKglTYV0YFm1CyDeIxXIvww=";
  };

  cargoHash = "sha256-13GQrXeyqX2e7tQsz5I5DRz05JrpptnJiGItNRIleog=";

  nativeBuildInputs = [ installShellFiles ];

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
