# UPSTREAM(dank-material-shell): auto-applying *named* output profiles would
# retire this file. displayProfileAutoSelect exists but also records unnamed
# profiles for every unknown output set, so it stays off here.
# UPSTREAM(niri): output events on the IPC event stream (missing in 26.04)
# would replace the udev watch below.
#
# dms knows which named profile matches the connected outputs but won't act on
# it; these scripts do: apply the match at session start, on display hotplug,
# and on the way back from resume/unlock.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  dms-toggle-outputs = pkgs.writeShellApplication {
    name = "dms-toggle-outputs";
    runtimeInputs = [ config.programs.dank-material-shell.package ];
    text = builtins.readFile ./dms-toggle-outputs.sh;
  };
  dms-output-watch = pkgs.writeShellApplication {
    name = "dms-output-watch";
    runtimeInputs = [
      pkgs.systemd # udevadm
      pkgs.coreutils # stdbuf, seq, sleep
      pkgs.gnugrep
      config.programs.dank-material-shell.package
      dms-toggle-outputs
    ];
    text = builtins.readFile ./dms-output-watch.sh;
  };
in
{
  # also handy manually: dms-toggle-outputs [--rotate]
  home.packages = [ dms-toggle-outputs ];

  systemd.user.services.dms-output-watch = {
    Unit = {
      Description = "Apply matched dms output profile on display hotplug";
      After = [ "dms.service" ];
      PartOf = [ "dms.service" ];
      # surface persistent failure once instead of restarting forever
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };
    Service = {
      ExecStart = lib.getExe dms-output-watch;
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "dms.service" ];
  };

  # outputs can change while the machine sleeps or sits locked; reapply on the
  # way back in
  services.swayidle.events = {
    unlock = lib.getExe dms-toggle-outputs;
    after-resume = lib.getExe dms-toggle-outputs;
  };
}
