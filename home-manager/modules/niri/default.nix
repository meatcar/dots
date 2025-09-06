{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.programs.niri;
  ghostty = config.programs.ghostty.package;
  winswitch = pkgs.writeScript "winswitch" ''
    #!/usr/bin/env bash
    ${lib.getExe pkgs.python3} -u ${./winswitch.py}
  '';
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
  inTerminal =
    {
      class ? "",
      title ? "",
    }:
    cmd:
    [
      "${lib.getExe ghostty}"
    ]
    ++ (if title == "" then [ ] else [ "--title=${title}" ])
    ++ (if class == "" then [ ] else [ "--class=${class}" ])
    ++ [ "-e" ]
    ++ cmd;
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
  programs.niri =
    let
      workspace-names = [
        "me"
        "work"
        "code"
      ];
      workspaces = lib.pipe workspace-names [
        (lib.imap1 (
          i: n: {
            name = "0${toString i}-${n}";
            value = {
              name = n;
            };
          }
        ))
        builtins.listToAttrs
      ];
    in
    {
      settings = {
        inherit workspaces;
        environment = { };
        xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";
        spawn-at-startup = [
          {
            command = [
              "${pkgs.dbus}/bin/dbus-update-activation-environment"
              "--systemd"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP"
            ];
          }
          {
            command = [
              "${lib.getExe pkgs.swayidle}"
              "timeout"
              (builtins.toString (60 * 15))
              "niri msg action power-off-monitors"
              "timeout"
              (builtins.toString (60 * 20))
              "dms ipc lock lock"
            ];
          }
          {
            command = [
              "${manage-monitors}/bin/manage-monitors"
            ];
          }
          {
            command = [
              "bash"
              "-c"
              "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store &"
            ];
          }
        ];
        cursor = {
          size = 16;
          theme = "Posy_Cursor";
        };
        input.focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "10%";
        };
        input.warp-mouse-to-focus = {
          enable = false;
          mode = "center-xy";
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
        outputs.${monitors.internal} = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
        outputs.${monitors.vertical} = {
          position = {
            x = 0;
            y = 0;
          };
          transform.rotation = 270;
        };
        outputs.${monitors.flex} = {
          variable-refresh-rate = true;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 60.0; # 120; # LG C2 supports 120Hz, but seems to have issues with red on black
          };
        };
        layout = {
          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 2.0 / 3.0; }
            { proportion = 1.0; }
          ];
          preset-window-heights = [
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 2.0 / 3.0; }
            { proportion = 1.0; }
          ];
          always-center-single-column = true;
          tab-indicator = {
            position = "right";
          };
          focus-ring = {
            active.gradient = {
              from = "#ca9ee6"; # catppuccin mauve
              to = "#c6d0f5"; # catppuccin text
              angle = 45;
              relative-to = "workspace-view";
            };
          };
          insert-hint.display.gradient =
            let
              inherit (cfg.settings.layout.focus-ring.active) gradient;
            in
            {
              from = "${gradient.from}80";
              to = "${gradient.to}80";
              angle = 45;

            };
        };

        switch-events.lid-close.action.spawn = [
          "systemctl"
          "suspend"
        ];
        binds = {
          "Mod+A".action.spawn = [
            "niri"
            "msg"
            "action"
            "toggle-overview"
          ];
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };
          "Mod+Return" = {
            repeat = false;
            action.spawn = [
              "${lib.getExe ghostty}"
              "+new-window"
              "--window-inherit-working-directory=false"
              "--gtk-single-instance=false"
            ];
          };
          "Mod+Shift+Return" = {
            repeat = false;
            action.spawn = "${lib.getExe ghostty}";
          };
          "Mod+P" = {
            repeat = false;
            action.spawn = [
              "dms"
              "ipc"
              "spotlight"
              "toggle"
            ];
          };
          "Mod+Shift+P" = {
            repeat = false;
            action.spawn = [
              "${lib.getExe specialArgs.nixpkgs-unstable._1password-gui}"
              "--quick-access"
              "--ozone-platform-hint=auto"
            ];
          };
          "Mod+N".action.spawn = [
            "dms"
            "ipc"
            "notifications"
            "toggle"
          ];
          "Mod+V".action.spawn = [
            "dms"
            "ipc"
            "clipboard"
            "toggle"
          ];
          "Mod+Tab".action.spawn = "${winswitch}";
          "Mod+Period".action.spawn = "${lib.getExe pkgs.smile}";
          "Mod+C".action.spawn = [
            "/bin/sh"
            "-c"
            "${lib.getExe pkgs.hyprpicker} | ${pkgs.wl-clipboard}/bin/wl-copy"
          ];
          "Mod+E".action.spawn = "${lib.getExe pkgs.nautilus}";
          "Mod+O".action.spawn = [
            "fuzzel-git-projects"
            "zeditor"
            "-n"
            "."
          ];

          "XF86AudioRaiseVolume".action.spawn = [
            "dms"
            "ipc"
            "audio"
            "increment"
            "1"
          ];
          "XF86AudioLowerVolume".action.spawn = [
            "dms"
            "ipc"
            "audio"
            "decrement"
            "1"
          ];
          "XF86AudioMute".action.spawn = [
            "dms"
            "ipc"
            "audio"
            "mute"
          ];
          "XF86AudioMicMute".action.spawn = [
            "dms"
            "ipc"
            "audio"
            "micmute"
          ];
          "XF86MonBrightnessUp".action.spawn = [
            "dms"
            "ipc"
            "brightness"
            "increment"
            "5"
            "" # default device
          ];
          "XF86MonBrightnessDown".action.spawn = [
            "dms"
            "ipc"
            "brightness"
            "decrement"
            "5"
            "" # default device
          ];

          "Mod+Q".action.spawn = [
            "bash"
            "-c"
            ''
              niri msg action power-off-monitors &&
              sleep 0.5 &&
              dms ipc lock lock
            ''
          ];
          "Mod+Shift+Q".action.spawn = [
            "dms"
            "ipc"
            "powermenu"
            "toggle"
          ];

          "Mod+D".action.close-window = { };
          "Mod+Z".action.expand-column-to-available-width = { };
          "Mod+Shift+Z".action.maximize-column = { };
          "Mod+F".action.fullscreen-window = { };
          "Mod+Shift+F".action.toggle-windowed-fullscreen = { };

          "Mod+B".action.center-window = { };

          "Mod+H".action.focus-column-or-monitor-left = { };
          "Mod+L".action.focus-column-or-monitor-right = { };
          "Mod+K".action.focus-window-or-workspace-up = { };
          "Mod+J".action.focus-window-or-workspace-down = { };
          "Mod+Shift+H".action.consume-or-expel-window-left = { };
          "Mod+Shift+L".action.consume-or-expel-window-right = { };
          "Mod+Shift+K".action.move-window-up = { };
          "Mod+Shift+J".action.move-window-down = { };
          "Mod+Alt+H".action.move-column-left-or-to-monitor-left = { };
          "Mod+Alt+L".action.move-column-right-or-to-monitor-right = { };
          "Mod+Alt+K".action.move-column-to-workspace-up = { };
          "Mod+Alt+J".action.move-column-to-workspace-down = { };
          "Mod+Ctrl+H".action.move-workspace-to-monitor-left = { };
          "Mod+Ctrl+L".action.move-workspace-to-monitor-right = { };
          "Mod+Ctrl+J".action.move-workspace-to-monitor-down = { };
          "Mod+Ctrl+K".action.move-workspace-to-monitor-up = { };
          "Mod+Ctrl+Shift+H".action.move-window-to-monitor-left = { };
          "Mod+Ctrl+Shift+L".action.move-window-to-monitor-right = { };
          "Mod+Ctrl+Shift+J".action.move-window-to-monitor-up = { };
          "Mod+Ctrl+Shift+K".action.move-window-to-monitor-down = { };
          "Mod+Ctrl+Alt+H".action.move-column-to-monitor-left = { };
          "Mod+Ctrl+Alt+L".action.move-column-to-monitor-right = { };
          "Mod+Ctrl+Alt+J".action.move-column-to-monitor-up = { };
          "Mod+Ctrl+Alt+K".action.move-column-to-monitor-down = { };
          "Mod+Bracketleft".action.swap-window-left = { };
          "Mod+Bracketright".action.swap-window-right = { };
          "Mod+Shift+Bracketleft".action.consume-window-into-column = { };
          "Mod+Shift+Bracketright".action.expel-window-from-column = { };

          "Mod+R".action.switch-preset-column-width = { };
          "Mod+Shift+R".action.switch-preset-window-height = { };
          "Mod+T".action.toggle-column-tabbed-display = { };
          "Mod+Minus".action.set-column-width = "-5%";
          "Mod+Equal".action.set-column-width = "+5%";
          "Mod+Shift+Minus".action.set-window-height = "-5%";
          "Mod+Shift+Equal".action.set-window-height = "+5%";
          "Mod+Shift+0".action.reset-window-height = { };

          "Mod+Space".action.switch-focus-between-floating-and-tiling = { };
          "Mod+Shift+Space".action.toggle-window-floating = { };

          "Mod+S".action.set-dynamic-cast-monitor = { };
          "Mod+Shift+S".action.clear-dynamic-cast-target = { };
          "Mod+Ctrl+S" = {
            repeat = false;
            action.spawn = [
              "bash"
              "-c"
              ''
                $output=$(niri msg --json focused-output | jq -r '.name')
                ${pkgs.wl-mirror}/bin/wl-mirror "$output"
              ''
            ];
          };
          "Mod+W".action.set-dynamic-cast-window = { };
          "Mod+Shift+W".action.clear-dynamic-cast-target = { };

          "Print".action.screenshot = { };
          "Mod+Print".action.screenshot-window = { };
          "Mod+Shift+Print".action.screenshot-screen = { };
          "Mod+Alt+Print".action.spawn = "${edit-screenshot}";
          "Mod+Ctrl+Print".action.spawn = inTerminal { title = "float"; } [
            "${screen-record}/bin/screen-record"
            "-g"
          ];
        }
        # Map 1-9 to workspaces
        // (lib.pipe 9 [
          (builtins.genList (x: x + 1))
          (builtins.map (
            n:
            let
              nstr = builtins.toString n;
            in
            [
              {
                name = "Mod+${nstr}";
                value = {
                  action.focus-workspace = n;
                };
              }
              {
                name = "Mod+Shift+${nstr}";
                value = {
                  action.move-window-to-workspace = n;
                };
              }
              {
                name = "Mod+Alt+${nstr}";
                value = {
                  action.move-column-to-workspace = n;
                };
              }
            ]
          ))
          lib.flatten
          builtins.listToAttrs
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
            open-focused = true;
          }
          {
            matches = [
              { is-floating = true; }
            ];
            shadow.enable = true;
            # shadow.draw-behind-window = true;
          }
          {
            matches = [ { app-id = "code"; } ];
            open-on-workspace = "code";
          }
          {
            matches = [ { is-window-cast-target = true; } ];
            focus-ring.active.color = "#f38ba8";
            focus-ring.inactive.color = "#7d0d2d";
            focus-ring.width = 4;
            border.inactive.color = "#7d0d2d";
            border.width = 4;
            shadow.color = "#7d0d2d70";
            tab-indicator.active.color = "#f38ba8";
            tab-indicator.inactive.color = "#7d0d2d";
          }
          {
            matches = [
              # Firefox / Zen PiP
              { title = "^Picture-in-Picture$"; }
              # Vivaldi
              { title = "^Picture in Picture$"; }
            ];
            open-floating = true;
            default-floating-position.relative-to = "bottom";
            default-floating-position.x = 0;
            default-floating-position.y = 0;
          }
          {
            # Meet
            matches = [
              {
                title = "^Meet - \w+-\w+-\w+$"; # not ending in browser name
              }
            ];
            open-floating = true;
            default-floating-position.relative-to = "top-left";
            default-floating-position.x = 0;
            default-floating-position.y = 0;
            default-window-height.proportion = 0.25;
            default-column-width.proportion = 0.25;
          }
          {
            matches = [
              { app-id="steam"; title="^notificationtoasts_\d+_desktop$";}
            ];
            default-floating-position.relative-to = "bottom-right";
            default-floating-position.x = 10;
            default-floating-position.y = 10;
          }
          {
            # Private Tray Floater
            matches = [
              { app-id = "opensnitch_ui"; }
            ];
            open-floating = true;
            default-floating-position.relative-to = "bottom-right";
            default-floating-position.x = 0;
            default-floating-position.y = 0;
            block-out-from = "screen-capture";
          }
          {
            # Public Floater
            matches = [
              { app-id = "float"; }
              { title = "float"; }
              { app-id = "it.mijorus.smile"; }
            ];
            open-floating = true;
          }
          {
            # Private Floater
            matches = [
              { app-id = "opensnitch_ui"; }
              # { title = "^.+ Mail - Vivaldi$"; } # gmail notification summon
              { app-id = "org.kde.polkit-kde-authentication-agent-1"; }
              { app-id = "org.gnome.polkit-gnome-authentication-agent-1"; }
            ];
            open-floating = true;
            block-out-from = "screen-capture";
          }
        ];
      };
    };
}
