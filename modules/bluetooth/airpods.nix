{ pkgs, ... }:
{
  hardware.bluetooth.settings.General.DeviceID = "bluetooth:004C:0000:0000";

  environment.systemPackages = [ pkgs.librepods ];
}
