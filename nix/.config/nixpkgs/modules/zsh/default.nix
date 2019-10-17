{ pkgs, ... }: {
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
        src = builtins.fetchGit {
          url = "https://github.com/MichaelAquilina/zsh-auto-notify.git";
          ref = "master";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-syntax-highlighting";
          ref = "master";
        };
      }
    ];
  };
}
