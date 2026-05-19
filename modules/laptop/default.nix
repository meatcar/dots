{ pkgs, ... }:
{
  imports = [
    ../power
    ../zswap
  ];

  networking.networkmanager.enable = true;

  # TODO: remove once we identify what's triggering hybrid-sleep.
  systemd.services.suspend-trigger-trace = {
    description = "Trace D-Bus sleep/suspend/hibernate method calls on login1";
    wantedBy = [ "multi-user.target" ];
    after = [ "dbus.service" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = pkgs.writeShellScript "suspend-trigger-trace" ''
        ${pkgs.dbus}/bin/dbus-monitor --system \
          "type='method_call',interface='org.freedesktop.login1.Manager'" \
          | ${pkgs.gnugrep}/bin/grep --line-buffered -E "Suspend|Hibern|Sleep"
      '';
    };
  };

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
