{ config, pkgs, ... }:
{
  home.packages = [ pkgs.direnv ];
  home.file.".direnvrc".source = ./direnvrc;
  programs.git.ignores = [ ".direnv/" ];

  programs.fish.shellInit = ''
    function autotmux --on-variable TMUX_SESSION_NAME
      if test -n "$TMUX_SESSION_NAME" && \
         test -z $TMUX && \
         command -s tmux >/dev/null
        if not tmux has-session -t $TMUX_SESSION_NAME
          tmux new-session -d -s "$TMUX_SESSION_NAME"
        end
        tmux new-session -t "$TMUX_SESSION_NAME"
      end
    end

  '';

}
