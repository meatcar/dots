{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [ grc ];

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ./config.fish;
    plugins =
      (builtins.map (p: { inherit (p) name src; }) (
        with pkgs.fishPlugins;
        [
          foreign-env
          grc
          puffer
          done
          autopair
          fzf-fish
        ]
      ))
      ++ (builtins.map
        (name: {
          inherit name;
          src = inputs.${name};
        })
        [
          # flake inputs
          "fish-docker-compose"
          "vscode-fish"
        ]
      );
    functions = {
      # In tmux, clear the title so tmux can compose it from pane_current_path +
      # pane_current_command + any app-set OSC title (e.g. Claude Code session name).
      fish_title.body = ''
        if set -q TMUX
          echo ""
        else
          prompt_pwd
          set cmd (status current-command)
          if [ "$cmd" != fish ]
            echo ":$cmd"
          end
        end
      '';
      # Store the literal command line in a per-pane tmux user option so the
      # pane border can show what the user actually typed (not just the process
      # name, which loses context for wrappers like "poetry run pytest").
      __tmux_track_cmd_pre = {
        onEvent = "fish_preexec";
        body = ''
          if set -q TMUX
            tmux set -p @pane_cmd $argv[1]
          end
        '';
      };
      __tmux_track_cmd_post = {
        onEvent = "fish_postexec";
        body = ''
          if set -q TMUX
            tmux set -p -u @pane_cmd
          end
        '';
      };
    };
  };
  programs.fzf.enableFishIntegration = false; # we use fzf.fish

  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
