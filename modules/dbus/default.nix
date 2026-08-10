{
  # dbus-broker holds an fd per client connection, so the session bus scales with
  # process count; the system bus already gets 16384, this never matched it
  systemd.user.services.dbus-broker = {
    overrideStrategy = "asDropin";
    serviceConfig.LimitNOFILE = 16384;
  };
}
