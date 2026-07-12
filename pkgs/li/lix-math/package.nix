{
  lib,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  boost,
  capnproto,
  nix-update-script,
  lix,
}:
clangStdenv.mkDerivation {
  pname = "lix-math";
  version = "0-unstable-2026-07-12";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-math";
    rev = "843489647490823379ce83337708624db33bf6d8";
    hash = "sha256-R3qHI+qU9O555ETzf9RZUO+FIN9Z+EhUsVqlJmCEgMM=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lix
    boost
    capnproto
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "adds some cool butilits to lix for maths";
    homepage = "https://github.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
