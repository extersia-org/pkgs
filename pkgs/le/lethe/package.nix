{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "lethe";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "f60f081fd6f4c84867f5791272aa4691a527698f";
    hash = "sha256-WHxfkiCsNaoiylMoF3WjRZRcJJG5YWbynZ3rw/5nqm4=";
  };

  cargoHash = "sha256-v0LUmTtj7RDXWmubdaaoEFYstSEvLnkFtuK5OfBP3og=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lethe \
      --bash <($out/bin/lethe completions bash) \
      --fish <($out/bin/lethe completions fish) \
      --zsh <($out/bin/lethe completions zsh)
  '';

  meta = {
    homepage = "https://tangled.org/isabelroses.com/lethe";
    description = "Never forget your NixOS deployments";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lethe";
  };
}
