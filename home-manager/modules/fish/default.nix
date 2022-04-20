{ pkgs, specialArgs, ... }:
let
  any-nix-shell-fish = pkgs.runCommand "any-nix-shell-fish"
    {
      buildInputs = with pkgs; [ which ];
    }
    ''
      mkdir $out
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right > $out/any-nix-shell.fish
    '';
in
{
  imports = [
    ../starship
    ../fzf
  ];
  home.packages = with pkgs; [ bat fasd fd any-nix-shell ];
  home.sessionVariables = { BAT_THEME = "ansi"; };

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile "${any-nix-shell-fish}/any-nix-shell.fish";
    shellInit = ''
      ${builtins.readFile ./config.fish}
      eval (starship init fish)
    '';
    plugins = [
      { name = "z"; src = specialArgs.inputs.z; }
      { name = "fish-docker-compose"; src = specialArgs.inputs.fish-docker-compose; }
      { name = "fzf-fish"; src = specialArgs.inputs.fzf-fish; }
      { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
    ];
  };

  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
