{
  config,
  specialArgs,
  ...
}: let
  declCachix = specialArgs.inputs.declarative-cachix;
in {
  imports = [(import "${declCachix}/home-manager-experimental.nix")];

  caches.cachix = import ../../caches.nix;
}
