{ config, ... }:
{
  nixpkgs.pkgs = import config.niv.nixpkgs { inherit (config.nixpkgs) config; };
}
