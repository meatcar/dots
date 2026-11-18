{ pkgs, ... }:
{
  imports = [
    ../modules/nix-your-shell
    ../modules/man
    ../modules/fish
    ../modules/starship
    ../modules/ssh
    ../modules/direnv
    ../modules/bat
    ../modules/lsd
    ../modules/btop
    ../modules/yazi
  ];

  home.packages = with pkgs; [
    curl
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LESS = "-R --mouse";
    DO_NOT_TRACK = "1";
    DISABLE_TELEMETRY = "1";
  };

  xdg.enable = true;
  programs.bash.enable = true;
  programs.less.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;
  programs.fzf.enable = true;
  programs.dircolors.enable = true;
  programs.zoxide.enable = true;
}
