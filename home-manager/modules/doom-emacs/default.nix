{ config, pkgs, lib, ... }:
{
  fonts.fontconfig.enable = lib.mkDefault true;
  home.packages = [
    (pkgs.google-fonts.override { fonts = [ "Bitter" ]; })
    pkgs.go-font
    pkgs.emacs-all-the-icons-fonts
    pkgs.fd
    pkgs.editorconfig-core-c
    pkgs.python3
    pkgs.pandoc
    pkgs.gitAndTools.delta
  ];
  programs.emacs.enable = true;
  xdg.configFile."doom" = {
    source = ./doom;
    recursive = true;
    onChange = "$HOME/.emacs.d/bin/doom sync";
  };
  programs.fish.shellInit = ''
    set -ax PATH $HOME/.emacs.d/bin
  '';
}
