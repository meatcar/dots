{ config, pkgs, ... }:
{
  programs.git.ignores = [ ".direnv/" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # source: https://github.com/direnv/direnv/wiki/Tmux-and-Fish
      session_name(){
        if [ -z "$*" ]; then
          echo session_name needs a name as argument >&2
          exit 1
        else
          export TMUX_SESSION_NAME="$*"
        fi
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
    interactiveShellInit = ''
      function autotmux --on-variable=TMUX_SESSION_NAME --description="autostart tmux when session gets set"
        set -l name (echo "$TMUX_SESSION_NAME" | tr '.' '-')
        if test -n "$name" && \
            test -z "$TMUX" && \
            command -s tmux >/dev/null
          if not tmux has-session -t "$name"
            tmux new-session -d -s "$name"
          end
          tmux new-session -t "$name"
        end
      end

      direnv hook fish | source
    '';
  };

}
