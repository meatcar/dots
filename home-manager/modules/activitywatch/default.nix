{
  pkgs,
  lib,
  ...
}:
{
  # FIXME: pinned to whatever nixpkgs ships, currently 0.13.2. Its heartbeat
  # query (`select ... where bucketrow=? order by starttime desc limit 1`)
  # hits indexes covering only one predicate, forcing a full bucket scan+sort
  # per write. Worked around by hand-adding composite indexes on the live db
  # (LOCAL-ONLY, not upstream schema, lost on a from-scratch rebuild):
  #   create index events_bucketrow_starttime on events(bucketrow, starttime);
  #   create index events_bucketrow_endtime   on events(bucketrow, endtime);
  #
  # Fixed properly in aw-server-rust#615: a single composite
  # (bucketrow, starttime DESC, endtime) index via a v4->v5 migration that
  # drops the old single-column indexes. Only in v0.14.0bN pre-releases so
  # far; nixpkgs tracks stable tags, hence the pin.
  #
  # FIXME: when nixpkgs moves past 0.13.2, drop the two hand-made indexes
  # above -- the v5 migration doesn't know about them and they'd survive as
  # redundant orphans slowing inserts. Should become an ExecStartPre instead
  # of a hand edit.
  # Watch: https://search.nixos.org/packages?channel=unstable&query=aw-server-rust
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    settings = {
      cors_regex = [ "chrome-extension://.*" ];
    };
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
    Unit.Requires = [ "activitywatch.service" ];
    Service = {
      # FIXME: no readiness signal from activitywatch.service; fixed delay is a guess.
      ExecStartPre = "/run/current-system/sw/bin/sleep 5";
      # make fault-tolerant
      Restart = "always";
    };
  };

  # FIXME: workaround for https://github.com/nix-community/home-manager/issues/5988
  systemd.user.targets.activitywatch = {
    Unit.After = lib.mkForce [ "graphical-session.target" ];
    Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
  };
}
