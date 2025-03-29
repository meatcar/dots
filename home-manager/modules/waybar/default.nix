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
              click-to-reveal = true;
            };
          }
          // attrs
          // {
            modules = ["custom/chevron"] ++ attrs.modules;
          };
      in {
        layer = "top";
        position = "right";
        modules-left = [
          "custom/notification"
          "niri/workspaces"
        ];
        modules-center = [];
        modules-right = [
          "tray"
          "group/audio-output"
          "group/audio-input"
          "group/net"
          "group/bt"
          "group/power"
          "group/time"
        ];
        "custom/chevron" = {
          format = "";
          tooltip = false;
        };
        "group/g-pings" = group {
          modules = ["custom/notification"];
        };
        "custom/notification" = {
          format = "{icon}";
          format-icons = rec {
            notification = "󰅸";
            none = "󰂜";
            dnd-notification = "󰪓";
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
            work = "";
            code = "";
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
        "group/audio-output" = group {
          modules = ["pulseaudio#output"];
        };
        "pulseaudio#output" = {
          justify = "center";
          format = "{icon}";
          format-bluetooth = "{icon}\n󰂯";
          tooltip-format = "{volume}% {icon} | {desc}";
          format-muted = "{icon}";
          format-icons = {
            headphone = "󰋋";
            headphone-muted = "󰟎";
            hands-free = "󰋎";
            hands-free-muted = "󰋐";
            headset = "󱡏";
            headset-muted = "󱡐";
            phone = "";
            phone-muted = "󰷯";
            portable = "";
            portable-muted = "󰷯";
            car = "";
            car-muted = "󰸜";
            default = ["󰕿" "󰖀" "󰕾"];
            default-muted = "󰸈";
          };
          on-click-right = "${lib.getExe pkgs.pavucontrol} --tab=3";
          on-click = "${pkgs.swayosd}/bin/swayosd-client --output-volume=mute-toggle";
          on-click-up = "${pkgs.swayosd}/bin/swayosd-client --output-volume=raise";
          on-click-down = "${pkgs.swayosd}/bin/swayosd-client --output-volume=lower";
          smooth-scrolling-threshold = 1;
        };
        "pulseaudio/slider#output" = {
          target = "sink";
          orientation = "vertical";
        };
        "group/audio-input" = group {
          modules = ["pulseaudio#input"];
        };
        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          tooltip-format = "{volume}% {format_source} ";
          on-click-right = "${lib.getExe pkgs.pavucontrol} --tab=4";
          on-click = "${pkgs.swayosd}/bin/swayosd-client --input-volume=mute-toggle";
          on-click-up = "${pkgs.swayosd}/bin/swayosd-client --input-volume=raise";
          on-click-down = "${pkgs.swayosd}/bin/swayosd-client --input-volume=lower";
        };
        "pulseaudio/slider#input" = {
          target = "source";
          orientation = "vertical";
        };
        "group/net" = group {
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
          on-click = "${lib.getExe pkgs.ghostty} --gtk-single-instance=false --command=${pkgs.networkmanager}/bin/nmtui";
        };
        "group/bt" = group {
          modules = ["bluetooth"];
        };
        "bluetooth" = {
          justify = "center";
          format-on = "";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "󰂱\n<b>{num_connections}</b>";
          format-connected-battery = "󰂱\n<small><b>{device_battery_percentage}%</b></small>";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "${lib.getExe pkgs.ghostty} --gtk-single-instance=false --command=${lib.getExe pkgs.bluetui}";
        };
        "group/power" = group {
          modules = ["battery"];
        };
        "battery" = {
          justify = "center";
          states = {
            good = 79;
            warning = 30;
            critical = 10;
          };
          format = "{icon}\n<small>{capacity}%</small>";
          format-charging = "<b>󰂄</b>\n<small>{capacity}%</small>";
          format-full = "󰁹";
          format-plugged = "󰁹";
          format-icons = [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo} {capacity}%\n{power} W\n {health}% ({cycles}  )";
        };
        "tray" = {
          icon-size = 18;
          spacing = 10;
          show-passive-items = true;
        };
        "group/time" = group {
          modules = ["clock" "clock#date"];
        };
        "clock" = {
          format = "{:%H\n%M}";
          tooltip-format = "{:%H:%M %Z (%z)}";
          timezones = [
            "Canada/Eastern"
            "Africa/Johannesburg"
          ];
          actions = {
            on-scroll-up = "tz_up";
            on-scroll-down = "tz_down";
          };
        };
        "clock#date" = {
          format = "<small>{:%d\n%m}</small>";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            week-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#fab387'><b>{}</b></span>";
              weekdays = "<span color='#f9e2af'><i>{}</i></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
              weeks = "<span color='#94e2d5'><b>W{}</b></span>";
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
