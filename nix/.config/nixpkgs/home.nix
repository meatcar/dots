{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kakoune
    htop
    mosh
    broot
    weechat
    neomutt
    isync
    msmtp
    ripgrep
  ];
  home.sessionVariables.XDG_RUNTIME_DIR = "/var/run/user/$UID";
  xdg.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./pkgs/git
    ./pkgs/fish
    ./pkgs/tmux
    ./pkgs/neovim
  ];
}
