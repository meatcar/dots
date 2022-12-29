{ config, pkgs, ... }:
let
  env_store = "~/Sync/backup/dev/env";
in
{
  programs.git.ignores = [ ".direnv/" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # source: https://github.com/direnv/direnv/wiki/Tmux-and-Fish
      # Takes a session name as an argument, defaulting to the directory name instead
      tmux_session(){
        TMUX_SESSION_NAME=''${*:-$(basename "$PWD")}
        # tmux doesn't like dots in session name
        export TMUX_SESSION_NAME=$(echo "$TMUX_SESSION_NAME" | tr . -)
        if test -z "$TMUX" && which tmux 2>&1 >/dev/null; then
          echo "starting session $TMUX_SESSION_NAME" >&2
          tmux new-session -t "$TMUX_SESSION_NAME"
        fi
      }

      session_name(){
        echo "direnv: 'session_name [...]' is deprecated, use just 'tmux_session' instead" >&2
        tmux_session "''${@:?session_name needs a name as argument}"
      }

      # store .direnv outside project dir
      # source: https://github.com/nix-community/nix-direnv/blob/master/README.md#storing-direnv-outside-the-project-directory
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
    '';
  };

  home.file.nixConf.text = ''
    keep-derivations = true
    keep-outputs = true
  '';

  programs.fish = {
    functions.link_env = {
      description = "symlink a .env file from the env store to this directory";
      body = ''
        set -l env_file "${env_store}"(systemd-escape -p $PWD/.env)
        if test -f "$env_file"
          ln -s "$env_file" .env
        end
      '';
    };
    functions.backup_env = {
      description = "backup a .env file replacing it with a symlink";
      body = ''
        set -l env_file "${env_store}"(systemd-escape -p $PWD/.env)
        if test ! -f "$env_file"
          mv -i .env "$env_file"
          link_env
        end
      '';
    };
  };

}
