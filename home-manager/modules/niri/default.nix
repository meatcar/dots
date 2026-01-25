# TODO: move away from rniri-flake due to slower maintenance
{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
let
  ghostty = config.programs.ghostty.package;
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
  monitors = {
    internal = "eDP-1";
    flex = "LG Electronics LG TV SSCR2 0x01010101";
    vertical = "Samsung Electric Company C27JG5x H4ZN100219";
  };
  manage-monitors = pkgs.writeShellScriptBin "manage-monitors" ''
    if niri msg outputs | grep -q "${monitors.flex}"; then
      niri msg output "${monitors.internal}" off
    else
      niri msg outputs "${monitors.internal}" on
    fi
  '';
in
{
  imports = [
    ../wayland
    ../fuzzel
    ../nautilus
    # ../waybar
    # ../gammastep.nix
    # ../swaync
    ../dms # replaces all of the above, and more.
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
      manage-monitors
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
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ pkgs.niri ];
  };
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
    include "dms/alttab.kdl"
    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/outputs.kdl"
    include "dms/wpblur.kdl"
    include "dms/cursor.kdl"
  '';
  xdg.configFile."niri/extra-config.kdl".text = ''
    xwayland-satellite { path "${lib.getExe pkgs.xwayland-satellite}"; }
    spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
    spawn-at-startup "${lib.getExe pkgs.swayidle}" "timeout" "${builtins.toString (60 * 15)}" "niri msg action power-off-monitors" "timeout" "${builtins.toString (60 * 20)}" "dms ipc lock lock"
    spawn-at-startup "${manage-monitors}/bin/manage-monitors"
    output "${monitors.internal}" {
        scale 1.0
        transform "normal"
        position x=0 y=0
    }
    output "${monitors.vertical}" {
        transform "270"
        position x=0 y=0
    }
    output "${monitors.flex}" {
      transform "normal"
      mode "3840x2160@60.0"
      variable-refresh-rate on-demand=false
    }
    binds {
      Mod+Return repeat=false { spawn "${lib.getExe pkgs.ghostty}" "--window-inherit-working-directory=false" "--gtk-single-instance=false"; }
      Mod+Shift+Return repeat=false { spawn "${lib.getExe pkgs.ghostty}"; }
      Mod+Shift+P repeat=false { spawn "${lib.getExe nixpkgs-unstable._1password-gui}" "--quick-access" "--ozone-platform=wayland"; }
      Mod+C { spawn "/bin/sh" "-c" "${lib.getExe pkgs.hyprpicker} | ${pkgs.wl-clipboard}/bin/wl-copy"; }
      Mod+E { spawn "${lib.getExe pkgs.nautilus}"; }
      Mod+Shift+S repeat=false { spawn "bash" "-c" "$output=$(niri msg --json focused-output | jq -r '.name') ${pkgs.wl-mirror}/bin/wl-mirror \"$output\""; }
      Mod+Alt+Print { spawn "${edit-screenshot}"; }
      Mod+Ctrl+Print { spawn "${lib.getExe pkgs.ghostty}" "--title=float" "-e" "${screen-record}/bin/screen-record" "-g"; }
    }
  '';
}
