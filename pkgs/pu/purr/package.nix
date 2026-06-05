{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "purr";
  version = "1.4.1-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "purr";
    rev = "823ce4258131ea3051aa9ff0516f057a63b20d76";
    hash = "sha256-lNU1N+L8ZdpuVhpSqxMF2hQ6zFZxohd6TIbWCsydjuA=";
  };

  cargoHash = "sha256-QaIbE56Ne4u2iE7ZX8D2dq6mLt3pgkP2EbvX6qAvmYk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Utility commands for managing userstyles";
    homepage = "https://github.com/uncenter/purr";
    license = lib.licenses.mit;
    mainProgram = "purr";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
