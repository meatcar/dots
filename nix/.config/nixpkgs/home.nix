{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kakoune
    htop
    mosh
    tmux
    fzf
    broot
    weechat
    neomutt
    isync
    msmtp
    ripgrep
  ];
  xdg.enable = true;
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./pkgs/git
    ./pkgs/neovim
    ./pkgs/fish
  ];
}
