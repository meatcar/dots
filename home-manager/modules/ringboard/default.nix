{ pkgs, ... }:
let
  listener-service = type: {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      Description = "Ringboard ${type}";
      Documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      Requires = [ "ringboard-server.service" ];
      BindsTo = [ "graphical-session.target" ];
      After = [
        "ringboard-server.service"
        "graphical-session.target"
      ];
    };
    Service = {
      ExecStart = "${pkgs.ringboard}/bin/ringboard-${type}";
      Restart = "on-failure";
      Slice = "session-ringboard.slice";
      Environment = [
        "RUST_LOG=trace"
      ];
    };
  };
in
{
  home.packages = [
    pkgs.ringboard
  ];
  systemd.user.services.ringboard-listener-x11 = listener-service "x11";
  systemd.user.services.ringboard-listener-wayland = listener-service "wayland";
  systemd.user.services.ringboard-server = {
    Install.WantedBy = [ "multi-user.target" ];
    Unit = {
      Description = "Ringboard Clipboard Server";
      Documentation = [
        "https://github.com/SUPERCILEX/clipboard-history"
      ];
      After = [ "multi-user.target" ];
    };
    Service = {
      Type = "notify";
      Environment = [
        "RUST_LOG=trace"
      ];
      ExecStart = "${pkgs.ringboard}/bin/ringboard-server";
      Restart = "on-failure";
      Slice = "session-ringboard.slice";
    };
  };

}
