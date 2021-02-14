{ config, pkgs, ... }:
{
  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call
    ];
    # TODO: undo powertop --auto-tune for logitech mouse
    # postBootCommands = ''
    #   echo on > /sys/bus/usb/devices/1-2.2/power/control
    # '';
  };
  powerManagement.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) s-tui powertop;
  };

  services = {
    upower.enable = true;
    acpid.enable = true;
    undervolt = {
      enable = true;
      analogioOffset = 0;
      coreOffset = -125;
      uncoreOffset = -125;
      gpuOffset = -70;
    };
    tlp = {
      enable = true;
      settings = {
        TLP_ENABLE = 1;
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        USB_BLACKLIST_PHONE = 1;
      };
    };
  };

  systemd.services = {
    powertop = {
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      description = "Powertop tunings";
      path = [ pkgs.kmod ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "no";
        ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      };
    };
    powertop-fix = {
      wantedBy = [ "powertop.service" ];
      after = [ "powertop.service" ];
      partOf = [ "powertop.service" ];
      description = "Fix powertop tunings for USB HID devices";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "no";
        ExecStart = "${pkgs.bash}/bin/bash ${./untune-hid.sh}";
      };
    };
  };

}
