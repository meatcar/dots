{
  pkgs,
  lib,
  ...
}: let
  DISPLAY = ":0";
  winswitch = pkgs.writeScript "winswitch" ''
    #!/usr/bin/env bash
    ${lib.getExe pkgs.python3} -u ${./winswitch.py}
  '';
in {
  imports = [
    ../wayland
    ../waybar
    ../fuzzel
    ../gammastep.nix
    ../swaync
    ../nautilus
  ];
  home.packages = with pkgs; [
    swaylock
    fuzzel
  ];
  services.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
  services.swayosd.enable = true;
  services.copyq.enable = true;
  programs.niri = let
    workspace-names = ["me" "work" "code"];
    workspaces = lib.pipe workspace-names [
      (lib.imap1 (i: n: {
        name = "0${toString i}-${n}";
        value = {name = n;};
      }))
      builtins.listToAttrs
    ];
  in {
    settings = {
      inherit workspaces;
      environment = {
        inherit DISPLAY;
      };
      spawn-at-startup = [
        {command = ["${lib.getExe pkgs.xwayland-satellite}" "${DISPLAY}"];}
        {command = ["${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "DISPLAY=${DISPLAY}" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"];}
      ];
      cursor = {
        size = 16;
        theme = "Posy_Cursor";
      };
      input.focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "10%";
      };
      input.touchpad = {
        dwtp = true;
        scroll-factor = 0.8;
        drag-lock = true;
      };
      input.trackpoint = {
        accel-profile = "flat";
      };
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      outputs."eDP-1" = {
        scale = 1.0;
      };
      layout.preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
      layout.preset-window-heights = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
      layout.always-center-single-column = true;
      layout.tab-indicator = {
        position = "right";
      };

      switch-events.lid-close.action.spawn = ["systemctl" "suspend"];
      binds =
        {
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};
          "Mod+Return".action.spawn = ["ghostty"];
          "Mod+Return".repeat = false;
          "Mod+P".action.spawn = ["fuzzel"];
          "Mod+P".repeat = false;
          "Mod+Shift+P".action.spawn = ["1password" "--quick-access"];
          "Mod+Shift+P".repeat = false;
          "Mod+Shift+N".action.spawn = ["swaync-client" "-t" "-sw"];
          "Mod+Shift+N".repeat = false;
          "Mod+N".action.spawn = ["swaync-client" "--hide-latest" "-sw"];
          "Mod+V".action.spawn = ["copyq" "toggle"];
          "Mod+W".action.spawn = "${winswitch}";
          "Mod+Period".action.spawn = "${lib.getExe pkgs.smile}";
          "Mod+C".action.spawn = "${lib.getExe pkgs.hyprpicker}";
          "Mod+E".action.spawn = "${lib.getExe pkgs.nautilus}";

          "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume=raise"];
          "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume=lower"];
          "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume=mute-toggle"];
          "XF86AudioMicMute".action.spawn = ["swayosd-client" "--input-volume=mute-toggle"];
          "XF86MonBrightnessUp".action.spawn = ["swayosd-client" "--brightness=raise"];
          "XF86MonBrightnessDown".action.spawn = ["swayosd-client" "--brightness=lower"];

          "Mod+Shift+Q".action.quit = {};

          "Mod+D".action.close-window = {};
          "Mod+O".action.focus-window-previous = {};
          "Mod+Z".action.maximize-column = {};
          "Mod+Shift+Z".action.fullscreen-window = {};
          "Mod+B".action.center-window = {};

          "Mod+Tab".action.focus-workspace-down = {};
          "Mod+Shift+Tab".action.focus-workspace-up = {};
          "Mod+Alt+Tab".action.move-column-to-workspace-down = {};
          "Mod+Shift+Alt+Tab".action.move-column-to-workspace-up = {};

          "Mod+H".action.focus-column-or-monitor-left = {};
          "Mod+L".action.focus-column-or-monitor-right = {};
          "Mod+K".action.focus-window-or-workspace-up = {};
          "Mod+J".action.focus-window-or-workspace-down = {};
          "Mod+Shift+H".action.consume-or-expel-window-left = {};
          "Mod+Shift+L".action.consume-or-expel-window-right = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Alt+H".action.move-column-left-or-to-monitor-left = {};
          "Mod+Alt+L".action.move-column-right-or-to-monitor-right = {};
          "Mod+Alt+K".action.move-column-to-workspace-up = {};
          "Mod+Alt+J".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+H".action.focus-monitor-left = {};
          "Mod+Ctrl+L".action.focus-monitor-right = {};
          "Mod+Ctrl+J".action.focus-monitor-up = {};
          "Mod+Ctrl+K".action.focus-monitor-down = {};
          "Mod+Ctrl+Shift+H".action.move-window-to-monitor-left = {};
          "Mod+Ctrl+Shift+L".action.move-window-to-monitor-right = {};
          "Mod+Ctrl+Shift+J".action.move-window-to-monitor-up = {};
          "Mod+Ctrl+Shift+K".action.move-window-to-monitor-down = {};
          "Mod+Ctrl+Alt+H".action.move-column-to-monitor-left = {};
          "Mod+Ctrl+Alt+L".action.move-column-to-monitor-right = {};
          "Mod+Ctrl+Alt+J".action.move-column-to-monitor-up = {};
          "Mod+Ctrl+Alt+K".action.move-column-to-monitor-down = {};
          "Mod+Bracketleft".action.swap-window-left = {};
          "Mod+Bracketright".action.swap-window-right = {};
          "Mod+Shift+Bracketleft".action.consume-window-into-column = {};
          "Mod+Shift+Bracketright".action.expel-window-from-column = {};

          "Mod+R".action.switch-preset-column-width = {};
          "Mod+Shift+R".action.switch-preset-window-height = {};
          "Mod+T".action.toggle-column-tabbed-display = {};
          "Mod+Minus".action.set-column-width = "-5%";
          "Mod+Equal".action.set-column-width = "+5%";
          "Mod+0".action.expand-column-to-available-width = {};
          "Mod+Shift+Minus".action.set-window-height = "-5%";
          "Mod+Shift+Equal".action.set-window-height = "+5%";
          "Mod+Shift+0".action.reset-window-height = {};

          "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
          "Mod+Shift+Space".action.toggle-window-floating = {};

          "Print".action.screenshot = {};
          "Mod+Print".action.screenshot-window = {};
          "Mod+Shift+Print".action.screenshot-screen = {};
        }
        # Map 1-9 to workspaces
        // (lib.pipe 9 [
          (builtins.genList (x: x + 1))
          (builtins.map (n: let
            nstr = builtins.toString n;
          in [
            {
              name = "Mod+${nstr}";
              value = {action.focus-workspace = n;};
            }
            {
              name = "Mod+Shift+${nstr}";
              value = {action.move-window-to-workspace = n;};
            }
            {
              name = "Mod+Alt+${nstr}";
              value = {action.move-column-to-workspace = n;};
            }
          ]))
          (lib.flatten)
          (builtins.listToAttrs)
        ]);

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 8.0;
            bottom-right = 8.0;
            top-left = 8.0;
            top-right = 8.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [{is-floating = true;}];
          shadow.enable = true;
          shadow.draw-behind-window = true;
        }
        {
          matches = [{app-id = "code";}];
          open-on-workspace = "code";
        }
        {
          matches = [{is-window-cast-target = true;}];
          focus-ring.active.color = "#f38ba8";
          focus-ring.inactive.color = "#7d0d2d";
          border.inactive.color = "#7d0d2d";
          shadow.color = "#7d0d2d70";
          tab-indicator.active.color = "#f38ba8";
          tab-indicator.inactive.color = "#7d0d2d";
        }
        {
          # Private Tray Floater
          matches = [{app-id = "copyq";}];
          open-floating = true;
          default-floating-position.relative-to = "bottom-right";
          default-floating-position.x = 0;
          default-floating-position.y = 0;
          block-out-from = "screen-capture";
        }
        {
          # Private Floater
          matches = [
            {app-id = "opensnitch_ui";}
            {title = "^.+ Mail - Vivaldi$";} # gmail notification summon
            {app-id = "org.kde.polkit-kde-authentication-agent-1";}
          ];
          open-floating = true;
          block-out-from = "screen-capture";
        }
        {
          # Public Floater
          matches = [{app-id = "it.mijorus.smile";}];
          open-floating = true;
        }
      ];
    };
  };
}
