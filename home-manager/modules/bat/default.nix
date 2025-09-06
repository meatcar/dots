{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  themes = inputs.catppuccin-bat;
in
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    themes = {
      "Catppuccin Latte" = {
        src = themes;
        file = "themes/Catppuccin Latte.tmTheme";
      };
      "Catppuccin Mocha" = {
        src = themes;
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };
  home.packages = [
    (lib.hiPrio (
      pkgs.writeShellScriptBin "bat" ''
        theme=$(get-theme)
        if [ "$theme" == "light" ]; then
          export BAT_THEME="Catppuccin Latte"
        else
          export BAT_THEME="Catppuccin Mocha"
        fi
        ${pkgs.bat}/bin/bat "$@"
      ''
    ))
  ];
}
