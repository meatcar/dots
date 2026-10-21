# External monitor brightness over DDC/CI. dms talks DDC itself through
# /dev/i2c-*; the ddcci kernel driver would claim address 0x37 and block it.
{ config, pkgs, ... }:
{
  hardware.i2c.enable = true;
  users.users.meatcar.extraGroups = [ config.hardware.i2c.group ];

  environment.systemPackages = [
    pkgs.ddcutil
    pkgs.ddcui
  ];
}
