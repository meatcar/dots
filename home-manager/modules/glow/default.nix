{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.glow
    # NOTE: glow's `auto` style never queries the terminal under tmux and assumes dark.
    # see https://github.com/muesli/termenv/blob/v0.16.0/termenv_unix.go#L235
    (lib.hiPrio (
      pkgs.writeShellScriptBin "glow" ''
        if [ -z "$GLOW_STYLE" ]; then
          if [ "$(get-theme 2>/dev/null)" = "light" ]; then
            export GLOW_STYLE=light
          else
            export GLOW_STYLE=dark
          fi
        fi
        exec ${lib.getExe pkgs.glow} "$@"
      ''
    ))
  ];
}
