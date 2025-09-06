{
  lib,
  pkgs,
  ...
}:
{
  services.opensnitch-ui.enable = true;
  systemd.user.services."opensnitch-ui" = {
    Unit = {
      Description = "Opensnitch UI";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.opensnitch-ui} --background";
      Restart = "always";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
