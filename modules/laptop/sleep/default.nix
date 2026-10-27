_:
{
  # NOTE: hybrid-sleep writes an image on every sleep (~60s entry); 7.2.2-7.2.8 hung there.
  # Suspend at once, and write the image only after a delay on battery.
  services.logind.settings.Login = {
    SleepOperation = "suspend-then-hibernate suspend";
    HandleLidSwitch = "sleep";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleSuspendKey = "sleep";
    HandlePowerKey = "sleep";
    HandlePowerKeyLongPress = "poweroff";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "2h";
    HibernateOnACPower = false;
  };

  # minimal hibernation image, see https://docs.kernel.org/power/swsusp.html
  # NOTE: default 2/5 of RAM hit ENOMEM and took ~98s to enter sleep.
  systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];
}
