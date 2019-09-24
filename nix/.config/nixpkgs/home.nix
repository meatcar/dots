{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    kakoune
    htop
    mosh
    fish
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

  imports = [./pkgs/git];
}
