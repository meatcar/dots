{ pkgs, ... }: {
  imports = [ ../starship ../fzf ];
  home.packages = [ pkgs.bat pkgs.any-nix-shell ];

  programs.fish = {
    enable = true;
    promptInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellInit = ''
      ${builtins.readFile ./config.fish}
      eval (starship init fish)
    '';
  };

  xdg.configFile."fish/fishfile".source = ./fishfile;
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
