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
