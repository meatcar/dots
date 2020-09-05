{ config, pkgs, lib, ... }:
{
  fonts.fontconfig.enable = lib.mkDefault true;
  home.packages = [
    pkgs.fontconfig
    (pkgs.nerdfonts.override {
      fonts = [ "Go-Mono" ];
    })
    pkgs.google-fonts
    pkgs.dejavu_fonts
    pkgs.symbola
    pkgs.emacs-all-the-icons-fonts
    pkgs.python3
    pkgs.pandoc
  ];
  programs.emacs = {
    enable = true;
  };
}
