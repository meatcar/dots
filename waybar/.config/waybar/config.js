{
    "layer": "bottom", // Waybar at top layer
    "position": "bottom", // Waybar position (top|bottom|left|right)
    // "height": 30, // Waybar height
    // "width": 1280, // Waybar width
    // Choose the order of the modules
    "modules-left": ["sway/workspaces", "sway/mode", "custom/spotify"],
    "modules-center": [],
    "modules-right": ["idle_inhibitor", "network", "cpu", "memory", "temperature", "backlight", "battery", "pulseaudio", "clock", "tray"],
    // Modules configuration
    "sway/workspaces": {
        "disable-scroll": true
        // "all-outputs": true,
    //     "format": "{name}: {icon}",
    //     "format-icons": {
    //         "1": "",
    //         "2": "",
    //         "3": "",
    //         "4": "",
    //         "5": "",
    //         "urgent": "",
    //         "focused": "",
    //         "default": ""
    //     }
    },
    "sway/mode": {
        "format": "<span style=\"italic\">{}</span>"
    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    "tray": {
        // "icon-size": 21,
        "spacing": 10
    },
    "clock": {
        "tooltip-format": "{:%Y-%m-%d | %H:%M}",
        "format-alt": "{:%Y-%m-%d}"
    },
    "cpu": {
        "format": "{usage}% "
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        "thermal-zone": 10,
        // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "critical-threshold": 80,
        // "format-critical": "{temperatureC}°C ",
        "format": "{temperatureC}°C "
    },
    "backlight": {
        // "device": "acpi_video1",
        "format": "{percent}% {icon}",
        "format-icons": ["", ""],
        "on-click": "brightnessctl -q set 100%",
        "on-click-right": "brightnessctl -q set 1%",
        "on-scroll-up": "brightnessctl -q set +5%",
        "on-scroll-down": "brightnessctl -q set 5%-"
    },
    "battery": {
        "states": {
            // "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": ["", "", "", "", ""]
    },
    "network": {
        // "interface": "wlp2s0", // (Optional) To force the use of this interface
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠"
    },
    "pulseaudio": {
        //"scroll-step": 1,
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": {
            "headphones": "",
            "handsfree": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", ""]
        },
        "on-click": "pavucontrol"
    },
    "custom/spotify": {
        "format": " {}",
        "max-length": 40,
        "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
    }
}
