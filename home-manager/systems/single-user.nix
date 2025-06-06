{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./common.nix ];
  # nixpkgs config
  nix.package = lib.mkForce pkgs.nixVersions.stable;
  nixpkgs.config = import ../config.nix;
  xdg.configFile."nixpkgs/config.nix".text =
    let
      seqToString = lib.generators.toPretty { };
      nixpkgsConfig = lib.filterAttrs (n: _v: n != "packageOverrides") config.nixpkgs.config;
    in
    seqToString nixpkgsConfig;
}
