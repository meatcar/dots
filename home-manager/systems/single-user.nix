{ config, lib, pkgs, ... }:
{
  # nixpkgs config
  nixpkgs.overlays = [ (import ../../overlays/wsl-open.nix) ];
  nixpkgs.config = import ../config.nix;
  xdg.configFile."nixpkgs/config.nix".text =
    let
      seqToString = lib.generators.toPretty { };
      nixpkgsConfig = lib.filterAttrs (n: v: n != "packageOverrides") config.nixpkgs.config;
    in
    seqToString nixpkgsConfig;

}
