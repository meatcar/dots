#!/bin/sh
#
# ~/.xinitrc

# set the cursor
xsetroot -cursor_name left_ptr
xrdb ~/.Xdefaults &

# set capslock to escape.
#xmodmap -e "remove lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Escape"

# set dual-head
dualhead &

# Fire up apps
xscreensaver  -no-splash &
xcompmgr -c -C&
(mpd /home/meatcar/.config/mpd/mpd.conf && mpc pause) &
urxvtd &
parcellite &
wicd-client &
# deluged &
sleep 1
# blueman-applet &

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
        
        statnot ~/.dwm/statnot.conf.py &
        startdwm
        ;;
esac
