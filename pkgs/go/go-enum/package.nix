{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-TmoiH1/G3yQmvpDb5+rkX20c41a59pAsVexVbjWtmfI=";
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
