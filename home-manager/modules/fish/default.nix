{ pkgs, ... }:
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
  imports = [ ../starship ../fzf ];
  home.packages = [ pkgs.bat pkgs.fasd pkgs.fd ];
  home.sessionVariables = { BAT_THEME = "base16"; };

  programs.fish = {
    enable = true;
    promptInit = builtins.readFile "${any-nix-shell-fish}/any-nix-shell.fish";
    shellInit = ''
      ${builtins.readFile ./config.fish}
      eval (starship init fish)
    '';
  };

  xdg.configFile."fish/fish_plugins" = {
    text = builtins.readFile ./fish_plugins;
    onChange = "fish -il -c 'fisher update'";
  };
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
