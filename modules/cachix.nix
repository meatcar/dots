{
  config,
  inputs,
  ...
}: {
  imports = [(import inputs.declarative-cachix)];

  cachix = import ../caches.nix;
}
