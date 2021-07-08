{ config, ... }:
{
  imports = [
    (
      let
        # TODO: use flakes so we can import this without the url
        declCachix = builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/82fcbb75db10b71b4962334723f75d2efd906859.tar.gz";
      in
      import "${declCachix}/home-manager.nix"
    )
  ];

  caches.cachix = [
    "nix-community"
  ];
}
