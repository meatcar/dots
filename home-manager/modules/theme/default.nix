# `get-theme` answers light|dark for theme-aware wrappers (bat, nvim, ...).
# Platform fallback below; theme daemons (darkman on Linux, wsl scripts)
# override it by shipping their own get-theme at normal priority.
{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    (lib.lowPrio (
      pkgs.writeShellScriptBin "get-theme" (
        if pkgs.stdenv.isDarwin then
          ''
            if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
              echo dark
            else
              echo light
            fi
          ''
        else
          ''
            echo dark
          ''
      )
    ))
  ];
}
