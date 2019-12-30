{ config, pkgs, ... }:
{
  imports = [ ../starship ];
  home.packages = [ pkgs.fzf pkgs.bat pkgs.any-nix-shell ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    initExtra = ''
      any-nix-shell zsh --info-right | source /dev/stdin
      eval "$(starship init zsh)"

      ${builtins.readFile ./keybinds.zsh}
    '';
    plugins = [
      {
        name = "zsh-auto-notify";
        src = config.sources.zsh-auto-notify;
      }
      {
        name = "zsh-syntax-highlighting";
        src = config.sources.zsh-syntax-highlighting;
      }
    ];
  };
}
