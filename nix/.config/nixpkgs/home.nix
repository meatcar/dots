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
    jq
  ];
  home.sessionVariables.XDG_RUNTIME_DIR = "/var/run/user/$UID";
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.man.enable = true;
  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "palenight";
      showMatching = true;
      ui = {
        enableMouse = true;
        assistant = "none";
      };
    };
  };

  imports = [
    ./pkgs/git
    ./pkgs/fish
    ./pkgs/tmux
    ./pkgs/neovim
  ];
}
