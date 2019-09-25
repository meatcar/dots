{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    mosh
    broot
    weechat
    neomutt
    isync
    msmtp
    ripgrep
    jq
    rootlesskit
    docker
    docker-compose

    nixfmt
    binutils
    gcc
    gnumake
    openssl
    pkgconfig
  ];
  home.sessionVariables.XDG_RUNTIME_DIR = "/var/run/user/$UID";
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.man.enable = true;

  imports = [ ./pkgs/git ./pkgs/fish ./pkgs/tmux ./pkgs/neovim ./pkgs/kakoune ];
}
