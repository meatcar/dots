# UPSTREAM(dank-material-shell): compositor wiring the HM module could ship
# behind an option, e.g. programs.dank-material-shell.compositor = "niri".
#
# The shell's life is tied to the compositor's: start after it, die with it,
# come back when it does.
_:
{
  systemd.user.services.dms = {
    # niri (Type=notify) signals READY only after the socket exists and the env
    # import into systemd completes, so ordering alone suffices — no readiness
    # polls needed
    Unit.After = [ "niri.service" ];
    Unit.BindsTo = [ "niri.service" ];
    Unit.StartLimitIntervalSec = 0;
    Service.RestartSec = 1; # restart slower, effectively a poll
  };

  # BindsTo stops dms when niri restarts, but graphical-session.target stays
  # active so nothing starts it back up; have niri uphold it. Side effect:
  # `systemctl --user stop dms` gets revived; stop niri for a shell-less session.
  xdg.configFile."systemd/user/niri.service.d/10-uphold-dms.conf".text = ''
    [Unit]
    Upholds=dms.service
  '';
}
