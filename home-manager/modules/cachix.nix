{ config, ... }:
{
  imports = [
    (
      let
        # TODO: use flakes so we can import this without the url
        declCachix = builtins.fetchGit {
          url = "https://github.com/jonascarpay/declarative-cachix";
          ref = "master";
          rev = "1986455ab3e55804458bf6e7d2a5f5b8a68defce";
        };
      in
      import "${declCachix}/home-manager-experimental.nix"
    )
  ];

  # nix-prefetch-url 'https://cachix.org/api/v1/cache/${name}'
  caches.cachix = [
    {
      name = "nix-community";
      sha256 = "1r0dsyhypwqgw3i5c2rd5njay8gqw9hijiahbc2jvf0h52viyd9i";
    }
    {
      name = "nixpkgs-wayland";
      sha256 = "1z0zbzdf6l0jyslxwcv7mciqmg2q5dl1nvb6q7drc0cd5gfiak2c";
    }
  ];
}
