{ ... }:
{
  imports = [
    ../../modules/power
  ];

  # more ram!
  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  # suspend-then-hibernate suspends faster, but the wakeup can leave the system in a stuck state.
  services.logind.extraConfig = ''
    SleepOperation=hybrid-sleep
  '';
  services.logind.lidSwitch = "sleep";
  services.logind.suspendKey = "sleep";
  services.logind.powerKey = "sleep";
  services.logind.powerKeyLongPress = "poweroff";
}
