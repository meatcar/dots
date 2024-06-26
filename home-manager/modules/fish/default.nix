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
  home.packages = with pkgs; [any-nix-shell grc];

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile "${any-nix-shell-fish}/any-nix-shell.fish";
    shellInit = builtins.readFile ./config.fish;
    plugins =
      (
        builtins.map (p: {inherit (p) name src;})
        (with pkgs.fishPlugins; [
          foreign-env
          grc
          puffer
          done
          autopair
          fzf-fish
        ])
      )
      ++ (
        builtins.map (name: {
          inherit name;
          src = specialArgs.inputs.${name};
        })
        [
          # flake inputs
          "fish-docker-compose"
          "vscode-fish"
        ]
      );
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
