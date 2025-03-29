{
  pkgs,
  lib,
  ...
}: {
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      awatcher = {
        package = pkgs.awatcher;
        settings = {
          idle-timeout-seconds = 180;
          poll-time-idle-seconds = 10;
          poll-time-window-seconds = 5;
        };
      };
    };
  };
  systemd.user.services.activitywatch-watcher-awatcher = {
    Unit.Requires = ["activitywatch.service"];
    Service = {
      # delay start for activiywatch to spin up.
      ExecStartPre = "/run/current-system/sw/bin/sleep 5";
      # make fault-tolerant
      Restart = "always";
    };
  };

  # FIXME: workaround for https://github.com/nix-community/home-manager/issues/5988
  systemd.user.targets.activitywatch = {
    Unit.After = lib.mkForce ["graphical-session.target"];
    Install.WantedBy = lib.mkForce ["graphical-session.target"];
  };
}
