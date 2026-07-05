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
  fmExe =
    if config.me.fileManager == "dolphin" then
      "${pkgs.kdePackages.dolphin}/bin/dolphin"
    else
      lib.getExe pkgs.nautilus;
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
      libnotify
    ];
    text = builtins.readFile ./screen-record.sh;
  };
  # Keep the keybind and the label passed to the notification in sync.
  recordKey = "Mod+Ctrl+Print";
in
{
  imports = [
    ../wayland
    ../fuzzel
    ../file-manager
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
  # dbus.packages for the file manager lives in ../file-manager
  xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk
    org.freedesktop.impl.portal.Access=gtk
    org.freedesktop.impl.portal.Notification=gtk
    org.freedesktop.impl.portal.Settings=gnome
    org.freedesktop.impl.portal.Secret=gnome-keyring
    ${lib.optionalString (
      config.me.fileManager == "dolphin"
    ) "org.freedesktop.impl.portal.FileChooser=kde"}
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
    binds {
      Mod+Return repeat=false hotkey-overlay-title="Terminal" { spawn "${lib.getExe ghostty}" "+new-window" "--working-directory=home"; }
      Mod+Shift+Return repeat=false hotkey-overlay-title="Terminal (inherit cwd)" { spawn "${lib.getExe ghostty}" "+new-window"; }
      Mod+Shift+Space repeat=false hotkey-overlay-title="1Password" { spawn "${lib.getExe nixpkgs-unstable._1password-gui}" "--quick-access" "--ozone-platform=wayland"; }
      Mod+E hotkey-overlay-title="Files" { spawn "${fmExe}"; }
      Mod+Shift+S repeat=false hotkey-overlay-title="Mirror screen" { spawn-sh "$output=$(niri msg --json focused-output | jq -r '.name') ${pkgs.wl-mirror}/bin/wl-mirror \"$output\""; }
      Mod+Alt+Print hotkey-overlay-title="Edit screenshot" { spawn "${edit-screenshot}"; }
      ${recordKey} repeat=false hotkey-overlay-title="Screen record" { spawn "${screen-record}/bin/screen-record" "-g" "-k" "${recordKey}"; }
    }
  '';
}
