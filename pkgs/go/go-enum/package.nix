{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-pEBx5292R8X06TLpv8kboNafiEfq9NWXvUoVVVQ0DVg=";
  };

  vendorHash = "sha256-NK4IeOmpzioo7c9PrncgwhCsIyt31sMnkv7qjuJbREo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
