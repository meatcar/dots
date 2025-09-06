{ config, pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = config.programs.steam.package.args.multiPkgs pkgs;
  };
}
