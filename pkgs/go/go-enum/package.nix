{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fFMTnbQ6RUGxvANHveB1YrXlppgUVTJIRB4v1sV3GH8=";
  };

  vendorHash = "sha256-hGfwb0GZCxc3EQWvxs7/fNVEVGGQE2I0B+MMaH7ecPM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
