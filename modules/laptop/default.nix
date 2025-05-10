{ ... }:
{
  imports = [
    ../../modules/power
  ];

  # more ram!
  zramSwap.enable = true;
  # why would we ever want to just suspend?
  systemd.services."systemd-suspend-then-hibernate".aliases = [ "systemd-suspend.service" ];

  networking.networkmanager.enable = true;
}
