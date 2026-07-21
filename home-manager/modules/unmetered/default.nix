{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.me.unmetered;
  watch = pkgs.writeShellApplication {
    name = "unmetered-watch";
    runtimeInputs = with pkgs; [
      systemd # busctl, systemctl
      glib # gdbus
      gawk
      libnotify
      coreutils
    ];
    text = builtins.readFile ./metered.sh + builtins.readFile ./watch.sh;
  };
in
{
  options.me.unmetered.suspend = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "user services stopped on metered connections, restarted off them";
  };

  config = {
    # up while the connection is known-unmetered. WantedBy= for units that
    # should always run then, me.unmetered.suspend for on-demand ones
    systemd.user.targets.unmetered = {
      Unit.Description = "Unmetered network connection";
    };

    systemd.user.services = lib.mkMerge [
      {
        unmetered-watch = {
          Unit = {
            Description = "Track NetworkManager metered state into unmetered.target";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${watch}/bin/unmetered-watch";
            Restart = "always";
            RestartSec = 5;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      }
      (lib.genAttrs cfg.suspend (_: {
        Unit = {
          PartOf = [ "unmetered.target" ];
          After = [ "unmetered.target" ];
        };
        # any start (incl. manual opt-in on metered) clears the resume marker
        Service.ExecStartPost = "${pkgs.coreutils}/bin/rm -f %t/unmetered.suspended/%n";
      }))
    ];
  };
}
