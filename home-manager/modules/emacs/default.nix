{ config, pkgs, lib, ... }:
let
  doom-emacs = pkgs.callPackage config.niv.nix-doom-emacs {
    doomPrivateDir = ./doom;
  };
in
{
  fonts.fontconfig.enable = lib.mkDefault true;
  home.packages = [
    pkgs.google-fonts
    pkgs.go-font
    pkgs.emacs-all-the-icons-fonts
    pkgs.fd
    pkgs.editorconfig-core-c
    pkgs.python3
    pkgs.pandoc
  ];
  programs.emacs.enable = true;
  xdg.configFile."doom" = {
    source = ./doom;
    recursive = true;
  };
}
