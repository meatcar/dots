{ config, pkgs, ... }:
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
    interactiveShellInit = ''
      # NOTE: Can't be in functions dir because of load order (I think...)
      #       needs to be loaded before direnv is hooked in
      function autotmux --on-variable=TMUX_SESSION_NAME \
          --description="autostart tmux when session name is set"
        if test -n "$TMUX_SESSION_NAME" && \
            test -z "$TMUX" && \
            command -s tmux >/dev/null
            echo "starting session $TMUX_SESSION_NAME" >&2
          tmux new-session -t "$TMUX_SESSION_NAME"
        end
      end

      direnv hook fish | source
    '';
  };

}
