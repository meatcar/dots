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
      # still flaps constantly, tripping cloud's misconfigured-alert detector
      health."enabled alarms" = "!10min_disk_backlog *";
    };
    configDir = {
      "health.d/sensors.conf" = ./health.d/sensors.conf;
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
