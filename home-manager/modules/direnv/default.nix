{
  config,
  pkgs,
  ...
}: let
  env_store = "~/Sync/backup/dev/env";
in {
  programs.git.ignores = [".direnv/"];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      tmux_session(){
        echo "tmux_session is deprecated and should be removed" >&2
      }

      session_name(){
        echo "session_name is deprecated and should be removed" >&2
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

  nix.settings = {
    keep-derivations = true;
    keep-outputs = true;
  };

  programs.fish = {
    interactiveShellInit = ''
      # NOTE: Can't be in functions dir because of load order (I think...)
      #       needs to be loaded before direnv is hooked in
      function autotmux_on_direnv_enter --on-variable=DIRENV_DIR \
        --description="start or attach to a tmux session when direnv is activated"
          test -z "$DIRENV_DIR" && return
          set -x TMUX_SESSION_NAME (basename "/$DIRENV_DIR" | tr . -)
          if test -z "$TMUX" && command -qs tmux
            echo "starting session $TMUX_SESSION_NAME" >&2
            tmux new-session -t "$TMUX_SESSION_NAME"
          end
      end
    '';
    functions = {
      link_env = {
        description = "symlink a .env file from the env store to this directory";
        body = ''
          set -l env_file "${env_store}"(systemd-escape -p $PWD/.env)
          if test -f "$env_file"
            ln -s "$env_file" .env
          end
        '';
      };
      backup_env = {
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
  };
}
