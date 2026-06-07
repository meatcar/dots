{
  pkgs,
  lib,
  ...
}:
{
  # BindsTo=graphical-session.target was removed to prevent D-Bus activation of
  # darkman from pulling graphical-session.target active before the compositor
  # is ready. BindsTo implicitly adds After=; restore that ordering explicitly
  # so darkman doesn't participate in the graphical-session.target activation
  # job before dms (which is After=graphical-session.target) is ready.
  systemd.user.services.darkman.Unit = {
    BindsTo = lib.mkForce [ ];
    After = [ "graphical-session.target" ];
  };

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
