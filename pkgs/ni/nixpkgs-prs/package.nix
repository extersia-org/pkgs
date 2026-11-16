{
  lib,
  rustPlatform,
  rust-bindgen,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "nixpkgs-prs";
  version = "0.5.1-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "nixpkgs-prs-bot";
    rev = "f18f3f2cf944f4434a8b9b56a8bb2ed51626af0e";
    hash = "sha256-mX3FqLEbYAvdQkIA/U6OWKFGBctPtQgbNywIuXBrWLE=";
  };

  cargoHash = "sha256-PP6fk4K0/pXm9kqMhgELWrHdnoDLcBO3nWukt3NkjZI=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rust-bindgen
    pkg-config
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://github.com/isabelroses/nixpkgs-prs-bot";
    description = "check the merged nixpkgs PRs for that day";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "nixpkgs-prs";
  };
}
