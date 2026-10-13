# Round the corners of browser-installed web-app (PWA) icons.
{ pkgs, lib, ... }:
let
  round-webapp-icons = pkgs.writeShellApplication {
    name = "round-webapp-icons";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.imagemagick
    ];
    text = builtins.readFile ./round-webapp-icons.sh;
  };
  # NOTE: sizes Chromium writes on install; PathChanged does not recurse
  sizes = [
    "32x32"
    "48x48"
    "128x128"
    "256x256"
  ];
in
{
  systemd.user.services.round-webapp-icons = {
    Unit.Description = "Round corners of web-app icons";
    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe round-webapp-icons} %h/.local/share/icons/hicolor";
    };
    # sweep at login for icons written while the watcher was down
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.paths.round-webapp-icons = {
    Unit.Description = "Watch for new web-app icons";
    Path.PathChanged = map (s: "%h/.local/share/icons/hicolor/${s}/apps") sizes;
    Install.WantedBy = [ "paths.target" ];
  };
}
