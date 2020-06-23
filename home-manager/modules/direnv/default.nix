{ config, pkgs, ... }:
{
  programs.git.ignores = [ ".direnv/" ];

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    stdlib = ''
      # source: https://github.com/direnv/direnv/wiki/Tmux-and-Fish
      session_name(){
        export TMUX_SESSION_NAME="$${*:?session_name needs a name as argument}"
      }
    '';
  };

  programs.fish.functions = {
    autotmux = {
      onVariable = "TMUX_SESSION_NAME";
      body = ''
        if test -n "$TMUX_SESSION_NAME" && \
           test -z $TMUX && \
           command -s tmux >/dev/null
          if not tmux has-session -t $TMUX_SESSION_NAME
            tmux new-session -d -s "$TMUX_SESSION_NAME"
          end
          tmux new-session -t "$TMUX_SESSION_NAME"
        end
      '';
    };
    nix-init = ''
      if [ -e ./.envrc ]
        echo ".envrc already exists, skipping." >&2
      else
        echo session_name (pwd | basename) >> .envrc
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
        $EDITOR default.nix
      end
    '';
  };

}
