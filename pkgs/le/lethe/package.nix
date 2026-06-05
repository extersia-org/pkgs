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
  version = "0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "8401a91c25992059afa3ca2b509c07d457e95651";
    hash = "sha256-RXqQWg9dTIKZbpSyg0cz4yoltfhOG8du0AfW1aEch1Y=";
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
