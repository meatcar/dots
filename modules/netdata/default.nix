{ pkgs, ... }:
let
  netdata = pkgs.symlinkJoin {
    name = "${pkgs.netdata.name}-with-ndsudo";
    paths = [ pkgs.netdata ];
    postBuild = ''
      mv "$out/libexec/netdata/plugins.d/ndsudo" "$out/libexec/netdata/plugins.d/ndsudo.org"
      ln -s /var/lib/netdata/ndsudo/ndsudo "$out/libexec/netdata/plugins.d/ndsudo"
    '';
    passthru = pkgs.netdata.passthru // {
      withNdsudo = true;
    };
    meta = pkgs.netdata.meta;
  };
in
{
  services.netdata = {
    enable = true;
    enableAnalyticsReporting = false;
    package = netdata;
    extraNdsudoPackages = [ pkgs.smartmontools ];
    config = {
      # disk backlog is meaningless on NVMe/dm; stock alert is silent but
      # still flaps constantly, tripping cloud's misconfigured-alert detector.
      # the memory three are replaced in health.d/severe.conf; disabling by name
      # lets upstream keep adding to ram.conf/swap.conf
      health."enabled alarms" = "!10min_disk_backlog !oom_kill !ram_available !used_swap *";
      plugins = {
        tc = "no"; # no traffic shaping on this laptop
        freeipmi = "no"; # no BMC
        "charts.d" = "no"; # legacy bash collectors, all superseded by go.d
        "python.d" = "no"; # legacy Python collectors, all superseded by go.d
        nfacct = "no"; # no NFACCT objects, and unwrapped so no CAP_NET_ADMIN
        ioping = "no"; # no ioping targets are configured
        perf = "no"; # blocked by this kernel's perf_event restrictions
        "logs-management" = "no"; # systemd-journal.plugin provides journal access
        statsd = "no"; # no local StatsD clients
      };
    };
    configDir = {
      # scripts.d logs a watch error every minute if its config dir is absent
      "scripts.d" = pkgs.emptyDirectory;
      "go.d/sd/net_listeners.conf" = ./net-listeners.conf;
      "health.d/sensors.conf" = ./health.d/sensors.conf;
      "health.d/severe.conf" = ./health.d/severe.conf;
      "health.d/systemdunits.conf" = ./health.d/systemdunits.conf;
      "health_alarm_notify.conf" = ./health_alarm_notify.conf;
    };
  };

  # netdata's sys_class_power_supply collector has no per-device exclude.
  # The Lenovo TrackPoint Keyboard II HID battery returns ENODATA when idle,
  # debugfs.plugin has no per-collector configuration, and this kernel does not
  # expose two zswap counters. apps.plugin races short-lived /proc entries, and
  # alarm-notify intentionally rejects initial CLEAR transitions with exit 1.
  # Drop only these expected lines at the journal layer.
  systemd.services.netdata.serviceConfig.LogFilterPatterns = [
    "~Cannot read file '/sys/class/power_supply/hid-0003:17EF:60EE"
    "~Cannot read file /sys/kernel/debug/zswap/(same_filled_pages|duplicate_entry)"
    "~Cannot process /proc/[0-9]+/(cmdline|io|limits|status)"
    "~SPAWN SERVER: child .*alarm-notify.sh.*'CLEAR' '(UNINITIALIZED|UNDEFINED)'"
  ];

  systemd.tmpfiles.rules = [
    "f /var/log/netdata/aclk.log 0640 netdata netdata - -"
  ];

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 19999 ];
}
