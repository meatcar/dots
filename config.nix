{ config, pkgs, lib, ... }:
let
  sources = import ./nix/sources.nix;
in
{
  options = import ./options { inherit lib; };
  config = rec {
    inherit sources;
    nixpkgs.pkgs = import config.sources.nixpkgs { inherit (config.nixpkgs) config; };
  };
}
