{
  pkgs,
  lib,
  ...
}:
{
  # Prevent darkman from pulling graphical-session.target active before the
  # compositor is ready. PartOf= (already set upstream) handles the lifecycle;
  # BindsTo= is the one that races the compositor via early D-Bus activation.
  # If this isn't enough, also add Restart=on-failure to xdg-desktop-portal-gtk.
  systemd.user.services.darkman.Unit.BindsTo = lib.mkForce [ ];

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
