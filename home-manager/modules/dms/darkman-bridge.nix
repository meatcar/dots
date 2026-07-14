# Local glue, nothing to upstream: dms drives light/dark; darkman rebroadcasts
# to its listeners (neovim, file-manager, ...). One-way by design — disarm
# darkman's rival drivers so the two can't fight: geoclue scheduling (dms
# schedules) and the gtk-theme hook (dms writes gsettings itself).
{ lib, pkgs, ... }:
let
  darkman-dms-bridge = pkgs.writeShellApplication {
    name = "darkman-dms-bridge";
    runtimeInputs = [
      pkgs.glib.bin # gdbus
      pkgs.darkman
      pkgs.gnugrep
      pkgs.coreutils # tail
    ];
    text = builtins.readFile ./darkman-dms-bridge.sh;
  };
in
{
  services.darkman.settings.usegeoclue = lib.mkForce false;
  services.darkman.darkModeScripts.gtk-theme = lib.mkForce "";
  services.darkman.lightModeScripts.gtk-theme = lib.mkForce "";

  systemd.user.services.darkman-dms-bridge = {
    Unit = {
      Description = "Mirror DMS appearance color-scheme into darkman";
      After = [
        "dms.service"
        "darkman.service"
        "xdg-desktop-portal.service"
        # explicit ordering vs the target suppresses its implicit After= on
        # wanted units, which otherwise cycles via dms.service and gets this
        # unit's start job deleted at boot
        "graphical-session.target"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe darkman-dms-bridge;
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
