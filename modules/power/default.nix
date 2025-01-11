{pkgs, ...}: {
  powerManagement.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) tlp s-tui powertop;
  };

  services = {
    upower.enable = true;
    tlp = {
      enable = true;
      settings = {
        TLP_ENABLE = 1;

        PLATFORM_PROFILE_ON_AC = "balanced"; # not "performance" to reduce fan noise
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        # turn off distracting backlight compensation
        AMDGPU_ABM_LEVEL_ON_AC = 0;
        AMDGPU_ABM_LEVEL_ON_BAT = 0;

        # only charge up to 80% of the battery capacity
        START_CHARGE_THRESH_BAT0 = "80";
        STOP_CHARGE_THRESH_BAT0 = "85";

        # don't power down phone
        USB_EXCLUDE_PHONE = 1;
      };
    };
  };

  # conflicts with tlp, see https://linrunner.de/tlp/faq/ppd.html
  services.power-profiles-daemon.enable = false;

  # systemd.services = {
  #   powertop-fix = {
  #     wantedBy = ["powertop.service"];
  #     after = ["powertop.service"];
  #     partOf = ["powertop.service"];
  #     description = "Fix powertop tunings for USB HID devices";
  #     serviceConfig = {
  #       Type = "oneshot";
  #       RemainAfterExit = "no";
  #       ExecStart = "${pkgs.bash}/bin/bash ${./untune-hid.sh}";
  #     };
  #   };
  # };
}
