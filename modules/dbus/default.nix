{
  # dbus-broker holds one fd per client connection, so the session bus scales
  # with process count -- two browsers' worth of renderers is enough to push it
  # near the ceiling. systemd keeps the soft NOFILE at 1024 only for legacy
  # select() callers, and the *system* bus is already provisioned at 16384;
  # the session bus was simply never raised to match. Exhausting it breaks
  # desktop IPC, and netdata caught it at 99.9% of the limit.
  systemd.user.services.dbus-broker = {
    overrideStrategy = "asDropin";
    serviceConfig.LimitNOFILE = 16384;
  };
}
