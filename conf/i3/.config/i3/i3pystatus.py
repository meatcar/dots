# vim: set ft=python

import subprocess

from . import Status

status = Status(standalone=True)

# Displays clock
status.register("clock",
        format="◷ %a %-d %b %l:%M:%S %P ",)

# Shows alsa default sink volume
status.register("alsa",
    card=1,
    format="♪ {volume}% ♪",)

status.register("backlight",
    format="☀ {percentage}% ☀",)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
    format="{status} {percentage:.2f}% {remaining:%E%hh:%Mm} {status}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "-⚡",
        "CHR": "+⚡",
        "FULL": "=⚡",
    },)

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
    format="{temp:.0f}°C",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load",
        format="▨ {avg1} {avg5}",)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="⛁ {total}G",)

# Has all the options of the normal network and adds some wireless specific things
# like quality and network names.
#
# Note: requires both netifaces-py3 and basiciw
status.register("wireless",
    interface="wlp1s0",
    format_up="{essid} {quality:1.0f}%",)

# Displays whether a DHCP client is running
status.register("runwatch",
    name="DHCP",
    path="/var/run/dhcpcd*.pid",)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
    #format="{title}{status}{album}",
    #status={
        #"pause": "▷",
        #"play": "▶",
        #"stop": "◾",
    #},)

status.run()
