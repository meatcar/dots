{
  pkgs,
  specialArgs,
  lib,
  ...
}: let
  any-nix-shell-fish =
    pkgs.runCommand "any-nix-shell-fish"
    {
      buildInputs = with pkgs; [which];
    }
    ''
      mkdir $out
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right > $out/any-nix-shell.fish
    '';
in {
  home.packages = with pkgs; [any-nix-shell grc wakatime];

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile "${any-nix-shell-fish}/any-nix-shell.fish";
    shellInit = builtins.readFile ./config.fish;
    plugins =
      (lib.mapAttrsToList (name: p: {
          inherit name;
          inherit (p) src;
        }) {
          inherit (pkgs.fishPlugins) foreign-env grc puffer wakatime-fish;
        })
      ++ [
        {
          name = "fish-docker-compose";
          src = specialArgs.inputs.fish-docker-compose;
        }
        {
          name = "fzf-fish";
          src = specialArgs.inputs.fzf-fish;
        }
        {
          name = "autopair";
          src = specialArgs.inputs.autopair-fish;
        }
        {
          name = "vscode-fish";
          src = specialArgs.inputs.vscode-fish;
        }
      ];
    functions = {
      fish_title.body = ''
        prompt_pwd
        set cmd (status current-command)
        if [ "$cmd" != fish ]
          echo ":$cmd"
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
