#!/bin/sh
#
# ~/.xinitrc

# set the cursor
xsetroot -cursor_name left_ptr
xrdb ~/.Xdefaults &


# set dual-head
dualhead &

# Fire up apps
xscreensaver  -no-splash &
xcompmgr -c -C&
(mpd /home/meatcar/.config/mpd/mpd.conf && mpc pause) &
urxvtd &
parcellite &
wicd-client &
deluged &
nitrogen --restore &
sleep 1
blueman-applet &

# Do wm-dependent stuff.
case $1 in
    kde)
        exec startkde
        ;;
    xmonad)
        dzconky &
        trayer --edge bottom --align right --widthtype pixel --width 200 \
            --transparent true --alpha 0 --tint 0x000000 --height 18 \
            --SetDockType true --SetPartialStrut true &
        exec ck-launch-session xmonad
        ;;
    *)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D

        while true; do 
            if acpi -a | grep off-line > /dev/null; then
                xsetroot -name "Bat. $( acpi -b | awk '{ print $4 " " $5 }' | tr -d ',' ) | Vol. $(amixer get Master | tail -1 | awk '{ print $5}' | tr -d '[]') | $(date +"%a, %b %d %R")"
            else
                xsetroot -name "Vol. $(amixer get Master | tail -1 | awk '{ print $5}' | tr -d '[]') | $(date +"%a, %b %d %R")"
            fi
            sleep 1s   
        done &


        startdwm
        ;;
esac
