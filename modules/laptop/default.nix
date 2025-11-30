{ ... }:
{
  imports = [
    ../../modules/power
  ];

  # more ram!
  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  # suspend-then-hibernate suspends faster, but the wakeup can leave the system in a stuck state.
  services.logind.settings.Login = {
    SleepOperation = "hybrid-sleep";
    LidSwitch = "sleep";
    SuspendKey = "sleep";
    PowerKey = "sleep";
    PowerKeyLongPress = "poweroff";
  };

}
