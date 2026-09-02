{
  config,
  lib,
  pkgs,
  ...
}:
let
  systemctl = "${config.systemd.package}/bin/systemctl";
  clamshell-check = pkgs.writeShellApplication {
    name = "clamshell-check";
    runtimeInputs = [ config.systemd.package ];
    text = builtins.readFile ./clamshell-check.sh;
  };
in
{
  systemd.services = {
    clamshell-inhibit = {
      description = "Ignore the lid switch while an external display is connected";
      serviceConfig.ExecStart = lib.concatStringsSep " " [
        "${config.systemd.package}/bin/systemd-inhibit"
        "--what=handle-lid-switch"
        "--who=clamshell"
        "--why='external display connected'"
        "--mode=block"
        "${pkgs.coreutils}/bin/sleep infinity"
      ];
    };

    clamshell-check = {
      description = "Toggle clamshell-inhibit from DRM connector state";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe clamshell-check;
      };
    };

    clamshell-release = {
      description = "Release the lid inhibitor after external displays stay disconnected";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${systemctl} stop clamshell-inhibit.service";
      };
    };
  };

  systemd.timers.clamshell-release.timerConfig = {
    OnActiveSec = "15s";
    RemainAfterElapse = false;
  };

  # Hotplug lands as a "change" uevent on the card, not the connector.
  # NOTE: SYSTEMD_WANTS never fires on remove, hence RUN.
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNEL!="*-*", ACTION=="add|change|remove", RUN+="${systemctl} start --no-block clamshell-check.service"
  '';
}
