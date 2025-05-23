{ config, pkgs, ... }:
{
  hardware.i2c.enable = true;
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [
      "ddcci"
      "ddcci_backlight"
    ];
  };

  environment.systemPackages = [
    pkgs.ddcutil
    pkgs.ddcui
  ];

  services.udev.extraRules = ''
    ACTION=="add",\
      SUBSYSTEM=="i2c-dev", ATTR{name}=="AMDGPU DM aux hw bus *",\
      TAG+="ddcci", TAG+="systemd",\
      ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"

    ACTION=="add",\
      SUBSYSTEM=="i2c-dev", ATTR{name}=="NVIDIA i2c adapter*",\
      TAG+="ddcci", TAG+="systemd",\
      ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  '';

  # pulled from https://github.com/crawford/machines/blob/main/modules/ddcci.nix
  systemd.services."ddcci@" = {
    description = "ddcci handler";

    after = [ "graphical.target" ];
    scriptArgs = "%i";
    serviceConfig.Type = "oneshot";

    script = ''
      INSTANCE=$1
      BUS=$(echo ''${INSTANCE} | cut -d "-" -f 2)

      echo "Trying to attach ddcci to ''${INSTANCE}"
      i=0
      while ((i++ < 5))
      do
        if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b ''${BUS}
        then
          echo ddcci 0x37 > "/sys/bus/i2c/devices/''${INSTANCE}/new_device"
          echo "ddcci attached to ''${INSTANCE}"
          exit 0
        else
          sleep 5
        fi
      done

      exit 1
    '';
  };
}
