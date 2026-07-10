{ pkgs, ... }:
let
  netdata-notify = pkgs.writeShellApplication {
    name = "netdata-notify";
    runtimeInputs = with pkgs; [
      systemd # journalctl
      jq
      libnotify # notify-send
      coreutils
    ];
    text = builtins.readFile ./notify.sh;
  };
in
{
  # push via journald: custom_sender systemd-cat's each transition, this
  # follows the identifier; journal read access comes from wheel membership
  systemd.user.services.netdata-notify = {
    Unit.Description = "Desktop notifications for netdata alert transitions";
    Service = {
      ExecStart = "${netdata-notify}/bin/netdata-notify";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
