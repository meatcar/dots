{ ... }:
{
  imports = [
    ../power
    ../zswap
  ];

  networking.networkmanager.enable = true;

  # suspend-then-hibernate suspends faster, but the wakeup can leave the system in a stuck state.
  services.logind.settings.Login = {
    SleepOperation = "hybrid-sleep";
    HandleLidSwitch = "sleep";
    HandleLidSwitchExternalPower = "sleep";
    HandleLidSwitchDocked = "ignore";
    HandleSuspendKey = "sleep";
    HandlePowerKey = "sleep";
    HandlePowerKeyLongPress = "poweroff";
  };

  boot.kernelParams = [
    # from https://discourse.ubuntu.com/t/fine-tuning-the-ubuntu-24-04-kernel-for-low-latency-throughput-and-power-efficiency/44834
    "preempt=full"
    "rcu_nocbs=all"
    "rcutree.enable_rcu_lazy=1" # see https://wiki.cachyos.org/configuration/general_system_tweaks/#enable-rcu-lazy
  ];

}
