{
    "layer": "bottom", // Waybar at top layer
    "position": "right", // Waybar position (top|bottom|left|right)
    // "height": 30, // Waybar height
    // "width": 1280, // Waybar width
    // Choose the order of the modules
        "modules-left": ["sway/workspaces", "sway/mode", "custom/mail", "custom/spotify"],
    "modules-center": [],
        "modules-right": ["network#icon", "custom/dnscrypt", "custom/net-metered", "network", "temperature", "backlight", "battery", "pulseaudio", "tray", "clock"],
    // Modules configuration
    "sway/workspaces": {
        "disable-scroll": true,
        // "all-outputs": true,
        "format": "{name}{icon}",
        "format-icons": {
            "urgent": "!!!",
            "default": ""
        }
    },
    "sway/mode": {
        "rotate": 270,
        "format": "<span style=\"italic\">{}</span>"
    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    "tray": {
        // "icon-size": 21,
        "spacing": 10
    },
    "clock": {
        "format": "{:%k\n%M}",
        "tooltip-format": "{:%Y-%m-%d | %H:%M}",
        "format-alt": "{:<small>-%u</small>\n20\n%y\n%m\n%d}"
    },
    "cpu": {
        "format": "{usage}% "
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        "thermal-zone": 10,
        // "hwmon-path": "/sys/class/hwmon/hwmon3/temp2_input",
        "critical-threshold": 80,
        // "format-critical": "{temperatureC}°C ",
        "format": "  \n{temperatureC}"
    },
    "backlight": {
        // "device": "acpi_video1",
        "format": " {icon} \n{percent}",
        "format-icons": [" ", " ", " "],
        "on-click": "brightnessctl -q set 100%",
        "on-click-right": "brightnessctl -q set 1%",
        "on-scroll-up": "brightnessctl -q set +2%",
        "on-scroll-down": "brightnessctl -q set 2%-"
    },
    "battery": {
        "states": {
            // "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "  \n{capacity}",
        "format-discharging": "{icon} \n{capacity}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": ["", "", "", "", ""]
    },
    "network#icon": {
        // "interface": "wlp2s0", // (Optional) To force the use of this interface
        "format-wifi": "  ",
        "format-ethernet": "  ",
        "format-disconnected": " ⚠ ",
        "on-click": "$TERMINAL -e nmtui"
    },
    "network": {
        "rotate": 270,
        // "interface": "wlp2s0", // (Optional) To force the use of this interface
        "format-wifi": "{essid} ({signalStrength}%)",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr}",
        "format-disconnected": "Disconnected",
        "tooltip-format": "{ifname} {ipaddr}/{cidr}",
        "on-click": "$TERMINAL -e nmtui"
    },
    "pulseaudio": {
        "scroll-step": 4,
        "format": " {icon}\n{volume}",
        "format-bluetooth": " {icon}\n{volume}",
        "format-muted": "  ",
        "format-icons": {
            "headphones": "",
            "handsfree": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
        "on-click-right": "pavucontrol"
    },
    "custom/spotify": {
        "rotate": 270,
        "format": " {}",
        "max-length": 45,
        "return-type": "json",
        "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null", // Script in resources folder
        "exec-if": "pgrep spotify",
        "on-click": "playerctl play-pause"
    },
    "custom/scratch": {
        "format": "",
        "tooltip": "Scratchpad Windows",
        "exec": "echo z",
        "on-click": "swaymsg scratchpad show"
    },
    "custom/dnscrypt": {
        "format": "{icon}",
        "return-type": "json",
        "exec": "$HOME/.config/waybar/systemd-status dnscrypt-proxy.service 2>/dev/null",
        "exec-if": "which systemctl",
        "interval": 5,
        "on-click": "$HOME/.config/waybar/systemd-status dnscrypt-proxy.service toggle 2>/dev/null",
        "format-icons": [ "", "" ]
    },
    "custom/net-metered": {
        "format": "{icon}",
        "return-type": "json",
        "exec": "$HOME/.config/waybar/net-metered 2>/dev/null",
        "exec-if": "which nmcli",
        "on-click": "$HOME/.local/bin/metered-connection toggle",
        "format-icons": [ "", "" ]
    },
    "custom/mail": {
        "format": "{icon}\n{}",
        "return-type": "json",
        "exec": "$HOME/.config/waybar/new-mail 2>/dev/null",
        "exec-if": "test -d $HOME/mail",
        "format-icons": [ "", "" ]
    }
}
