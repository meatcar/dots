{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "netdata" ];

  services.netdata = {
    enable = true;
    enableAnalyticsReporting = false;
    package = pkgs.netdata.override {
      withCloudUi = true;
      withNdsudo = true; # go.d smartctl collector runs smartctl via ndsudo
    };
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
        nfacct = "no"; # no NFACCT objects, and unwrapped so no CAP_NET_ADMIN
      };
    };
    configDir = {
      # scripts.d logs a watch error every minute if its config dir is absent
      "scripts.d" = pkgs.emptyDirectory;
      "health.d/sensors.conf" = ./health.d/sensors.conf;
      "health.d/severe.conf" = ./health.d/severe.conf;
      "health.d/systemdunits.conf" = ./health.d/systemdunits.conf;
      "health_alarm_notify.conf" = ./health_alarm_notify.conf;
    };
  };

  # netdata's sys_class_power_supply collector has no per-device exclude.
  # The Lenovo TrackPoint Keyboard II HID battery returns ENODATA when idle,
  # spamming the journal once a second. Drop those lines at the journald layer.
  systemd.services.netdata.serviceConfig.LogFilterPatterns = [
    "~Cannot read file '/sys/class/power_supply/hid-0003:17EF:60EE"
  ];

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 19999 ];
}
