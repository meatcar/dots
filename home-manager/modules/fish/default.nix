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
  home.packages = with pkgs; [ any-nix-shell ];

  programs.fish =
    {
      enable = true;
      interactiveShellInit = builtins.readFile "${any-nix-shell-fish}/any-nix-shell.fish";
      shellInit = builtins.readFile ./config.fish;
      plugins =
        [
          { name = "fish-docker-compose"; src = specialArgs.inputs.fish-docker-compose; }
          { name = "fzf-fish"; src = specialArgs.inputs.fzf-fish; }
          { name = "autopair"; src = specialArgs.inputs.autopair-fish; }
          { name = "foreign-env"; inherit (pkgs.fishPlugins.foreign-env) src; }
        ];
      functions = {
        fish_title.body = ''
          prompt_pwd
          set cmd (status current-commandline)
          if [ "$cmd" != fish ]
            echo " $cmd"
          end
        '';
      };
    };
  programs.fzf.enableFishIntegration = false; # we use fzf.fish

  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
