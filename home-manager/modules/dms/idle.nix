# Idle policy: blank displays, then lock. dms is the locker, via loginctl.
{ pkgs, ... }:
{
  # the HM module runs swayidle as a user service, so config changes apply on
  # switch without a relogin — but it hardcodes a bash-only PATH, so commands
  # need absolute store paths
  services.swayidle = {
    enable = true; # default extraArgs = [ "-w" ] (wait for command to complete)
    timeouts = [
      {
        timeout = 60 * 15;
        command = "/run/current-system/sw/bin/niri msg action power-off-monitors";
        # no resumeCommand: niri repowers monitors on input automatically
      }
      {
        timeout = 60 * 20;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];
  };
  # needs the compositor socket; same ordering as dms
  systemd.user.services.swayidle.Unit.After = [ "niri.service" ];
}
