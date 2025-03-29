{
  pkgs,
  lib,
  ...
}: {
  services.darkman = {
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
    };
  };
  # xdg.portal.config.common = {
  #   "org.freedesktop.impl.portal.Settings" = "darkman";
  # };
  home.packages = [
    (pkgs.writeShellScriptBin "get-theme" ''
      ${lib.getExe pkgs.darkman} get
    '')
  ];
}
