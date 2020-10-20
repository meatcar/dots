{ config, pkgs, ... }:
{
  programs.git.ignores = [ ".direnv/" ];

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
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
    '';
  };

  programs.fish = {
    shellInit = ''
      function autotmux --on-variable TMUX_SESSION_NAME --description "autostart tmux when session gets set"
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
    '';

    functions = {
      nix-init = ''
        if [ -e ./.envrc ]
          echo ".envrc already exists, skipping." >&2
        else
          # tmux doesn't like dots in session names
          echo session_name (basename "$PWD") >> .envrc
          echo use nix >> .envrc
          direnv allow
        end

        if [ -e shell.nix ]
          echo "shell.nix already exists, skipping." >&2
        else
          echo >shell.nix "\
        {pkgs ? import <nixpkgs> {}}:
        pkgs.mkShell {
          name = \"env\";
          buildInputs = [];
        }
        "
        end
      '';
    };
  };

}
