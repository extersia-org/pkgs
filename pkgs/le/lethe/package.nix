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
  version = "0-unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lethe";
    rev = "7f276f70069144ff2aa6c68292ac865b20c54b46";
    hash = "sha256-0bgoujn1lN4ftBSaCyTll9LwVsyu/p/PIhXE2m9LFgQ=";
  };

  cargoHash = "sha256-WFPiBmTbkBiZhKtGzEse97QetwPjy36WSxyqrOPMdMw=";

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
