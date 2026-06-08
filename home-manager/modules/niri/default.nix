# TODO: move away from rniri-flake due to slower maintenance
{
  config,
  pkgs,
  lib,
  inputs,
  nixpkgs-unstable,
  ...
}:
let
  ghostty = config.programs.ghostty.package;
  dms = lib.getExe inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
  edit-screenshot = pkgs.writeScript "editScreenshot" ''
    DIRECTORY=~/Pictures/Screenshots
    LATEST=$(ls -t "$DIRECTORY" | head -n 1)
    EXTENSION="''${LATEST##*.}"
    NAME="''${LATEST%.*}"
    OUTPUT_FILE="$DIRECTORY/$NAME-edited-$(date +%Y-%m-%d_%H-%M-%S).$EXTENSION"
    ${lib.getExe pkgs.satty} \
      --file "$LATEST"  --output-filename "$OUTPUT_FILE" \
      --early-exit \
      "$@"
  '';
  screen-record = pkgs.writeShellApplication {
    name = "screen-record";
    runtimeInputs = with pkgs; [
      wf-recorder
      slurp
      ffmpeg
      wl-clipboard
    ];
    text = builtins.readFile ./screen-record.sh;
  };
in
{
  imports = [
    ../wayland
    ../fuzzel
    ../nautilus
    ../dms # shell/bar/gui
  ];
  home.packages =
    (with pkgs; [
      # swaylock
      fuzzel
      # swww
      # waypaper
      xwayland-satellite
    ])
    ++ [
      screen-record
    ];
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  dbus.packages = [ pkgs.nautilus ];
  xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk
    org.freedesktop.impl.portal.Access=gtk
    org.freedesktop.impl.portal.Notification=gtk
    org.freedesktop.impl.portal.Settings=gnome
    org.freedesktop.impl.portal.Secret=gnome-keyring
  '';
  services.swayosd.enable = true;
  # services.swww.enable = true;
  programs.fuzzel.settings.main.launch-prefix = "niri msg action spawn --";
  programs.fuzzel.settings.main.terminal = "${lib.getExe ghostty}";
  xdg.configFile."niri/config.kdl".text = ''
    // We establish defaults
    ${builtins.readFile ./config.kdl}
    // then override with custom settings
    include "extra-config.kdl"
    // dms provides gui controls for these settings
    include optional=true "dms/alttab.kdl"
    include optional=true "dms/binds.kdl"
    include optional=true "dms/colors.kdl"
    include optional=true "dms/cursor.kdl"
    include optional=true "dms/layout.kdl"
    include optional=true "dms/outputs.kdl"
    include optional=true "dms/windowrules.kdl"
    include optional=true "dms/wpblur.kdl"
  '';
  xdg.configFile."niri/extra-config.kdl".text = ''
        xwayland-satellite { path "${lib.getExe pkgs.xwayland-satellite}"; }
        spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
        spawn-at-startup "${lib.getExe pkgs.swayidle}" "timeout" "${builtins.toString (60 * 15)}" "niri msg action power-off-monitors" "timeout" "${builtins.toString (60 * 20)}" "loginctl lock-session" "unlock" "systemctl --user restart dms.service"
        binds {
          Mod+Return repeat=false { spawn "${lib.getExe pkgs.ghostty}" "--window-inherit-working-directory=false" "--gtk-single-instance=false"; }
          Mod+Shift+Return repeat=false { spawn "${lib.getExe pkgs.ghostty}"; }
          Mod+Shift+Space repeat=false { spawn "${lib.getExe nixpkgs-unstable._1password-gui}" "--quick-access" "--ozone-platform=wayland"; }
          Mod+E { spawn "${lib.getExe pkgs.nautilus}"; }
          Mod+Shift+S repeat=false { spawn "bash" "-c" "$output=$(niri msg --json focused-output | jq -r '.name') ${pkgs.wl-mirror}/bin/wl-mirror \"$output\""; }
    Mod+Alt+Print { spawn "${edit-screenshot}"; }
          Mod+Ctrl+Print { spawn "${lib.getExe pkgs.ghostty}" "--title=float" "-e" "${screen-record}/bin/screen-record" "-g"; }
        }
  '';
}
