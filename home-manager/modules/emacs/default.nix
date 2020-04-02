{ config, pkgs, ... }:
let
  doom-emacs = pkgs.callPackage config.niv.nix-doom-emacs {
    doomPrivateDir = ./doom;
  };
in
{
  # home.packages = [ doom-emacs ];
  programs.emacs.enable = true;
  xdg.configFile."doom" = {
    source = ./doom;
    recursive = true;
  };
}
