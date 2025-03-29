{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # based on https://github.com/niksingh710/gdots/blob/master/.config/waybar/bars/top.jsonc
    settings = {
      mainBar = let
        group = attrs:
          {
            orientation = "inherit";
          }
          // attrs;
        drawerGroup = attrs:
          group {
            drawer = {
              transition-duration = 500;
              transition-left-to-right = true;
            };
          }
          // attrs;
      in {
        layer = "top";
        position = "right";
        modules-left = [
          "custom/notification"
          "niri/workspaces"
        ];
        modules-center = ["privacy"];
        modules-right = [
          "tray"
          "group/audio"
          "group/net"
          "group/bt"
          "group/power"
          "group/time"
        ];
        "custom/notification" = {
          format = "{icon}";
          format-icons = rec {
            notification = "<span foreground='red'>󰅸</span>";
            none = "󰂜";
            dnd-notification = "<span foreground='yellow'>󰪓</span>";
            dnd-none = "󰪓";
            inhibited-notification = notification;
            inhibited-none = none;
            dnd-inhibited-notification = dnd-notification;
            dnd-inhibited-none = dnd-none;
          };
          return-type = "json";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client --subscribe-waybar";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
          on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client --close-latest";
          escape = "true";
        };
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            me = "󰁥";
            "1" = "󰁥";
            work = "";
            "2" = "";
            code = "";
            "3" = "";
            # "4" = "󱂋";
            # "5" = "󰬃";
            # "6" = "󱂍";
            # "7" = "󱂎";
            # "8" = "󱂏";
            # "9" = "󱂐";
          };
        };
        "privacy" = {
          orientation = "vertical";
          icon-spacing = 4;
          icon-size = 14;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };
        "group/audio" = drawerGroup {
          modules = ["pulseaudio" "pulseaudio#mic" "pulseaudio/slider"];
        };
        "pulseaudio" = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          tooltip-format = "{volume}% {icon} | {desc}";
          format-muted = "󰖁";
          format-icons = {
            headphones = "󰋌";
            handsfree = "󰋌";
            headset = "󰋌";
            phone = "";
            portable = "";
            car = " ";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click-middle = "${lib.getExe pkgs.myxer}";
          on-click = "${pkgs.swayosd}/bin/swayosd-client --output-volume=mute-toggle";
          on-click-up = "${pkgs.swayosd}/bin/swayosd-client --output-volume=raise";
          on-click-down = "${pkgs.swayosd}/bin/swayosd-client --output-volume=lower";
          smooth-scrolling-threshold = 1;
        };
        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          tooltip-format = "{volume}% {format_source} ";
          on-click-middle = "${lib.getExe pkgs.pavucontrol} --tab=4";
          on-click = "${pkgs.swayosd}/bin/swayosd-client --input-volume=mute-toggle";
          on-click-up = "${pkgs.swayosd}/bin/swayosd-client --input-volume=raise";
          on-click-down = "${pkgs.swayosd}/bin/swayosd-client --input-volume=lower";
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 140;
          orientation = "vertical";
        };
        "group/net" = drawerGroup {
          modules = ["network"];
        };
        "network" = rec {
          format = "{icon}";
          format-icons = {
            wifi = [format-wifi];
            ethernet = [format-ethernet];
            disconnected = [format-disconnected];
          };
          format-wifi = "󰤨";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          format-linked = "󰈁";
          tooltip-format = "{ifname}: {ipaddr}";
          tooltip-format-wifi = "${format-wifi} {essid} ({signalStrength}%)\n{ipaddr} | {frequency} MHz";
          tooltip-format-ethernet = "${format-ethernet} {ifname}\n{ipaddr} | {frequency} MHz";
          on-click = "${lib.getExe pkgs.ghostty} --command=${pkgs.networkmanager}/bin/nmtui";
        };
        "group/bt" = drawerGroup {
          modules = ["bluetooth" "bluetooth#status"];
        };
        "bluetooth" = {
          format-on = "";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "<b></b>";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "${lib.getExe pkgs.ghostty} --command=${lib.getExe pkgs.bluetui}";
        };
        "bluetooth#status" = {
          format-on = "";
          format-off = "";
          format-disabled = "";
          format-connected = "<b>{num_connections}</b>";
          format-connected-battery = "<small><b>{device_battery_percentage}%</b></small>";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "${lib.getExe pkgs.ghostty} --command=${lib.getExe pkgs.bluetui}";
        };
        "group/power" = drawerGroup {
          modules = ["battery"];
        };
        "battery" = {
          rotate = 270;
          states = {
            good = 79;
            warning = 30;
            critical = 10;
          };
          format = "{icon}";
          format-charging = "<b>{icon} </b>";
          format-full = "<span color='#82A55F'><b>{icon}</b></span>";
          format-icons = [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo} {capacity} % | {power} W\n {health}% ({cycles}  )";
        };
        "tray" = {
          icon-size = 18;
          spacing = 10;
        };
        "group/time" = drawerGroup {
          modules = ["clock"];
        };
        "clock" = {
          format = "{:%H\n%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            week-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><i>{}</i></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
            on-click-middle = "shift_reset";
          };
        };
      };
    };
    style = builtins.readFile ./waybar-style.css;
  };
}
