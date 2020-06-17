{ pkgs, ... }: {
  imports = [ ../starship ../fzf ];
  home.packages = [ pkgs.bat pkgs.any-nix-shell pkgs.fasd ];
  home.sessionVariables = { BAT_THEME = "base16"; };

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

  xdg.configFile."fish/fishfile" = {
    text = builtins.readFile ./fishfile;
    onChange = "fish -l -c fisher";
  };
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };

  programs.broot.enable = true;
  programs.broot.verbs = {
    "rm" = { execution = "rm -rf {file}"; leave_broot = false; };
    "mv" = { execution = "mv {file} {newpath:path-from-parent}"; leave_broot = false; };
    "cp" = { execution = "cp {file} {newpath:path-from-parent}"; leave_broot = false; };
    "mkdir" = { execution = "mkdir -p {subpath:path-from-directory}"; leave_broot = false; };
  };
}
