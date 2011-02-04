#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec xterm
case $1 in
    kde)
        exec startkde
        ;;
    *)
        # set the cursor
        xsetroot -cursor_name left_ptr
        xrdb ~/.Xdefaults &

        # set dual-head
        dualhead &

        # Fire up apps
        xscreensaver  -no-splash &
        xcompmgr -c -C&
        mpd /home/meatcar/.config/mpd/mpd.conf &&
        mpc pause &

        if [ -x /usr/bin/gnome-power-manager ] ; then
           sleep 3
           gnome-power-manager&
        fi
        
        udiskie &
        urxvtd &
        parcellite &
        wicd-client &
        deluged &
        nitrogen --restore &
#        wallp &
        sleep 1
        dzconky &
        blueman-applet &
        trayer --edge bottom --align right --widthtype pixel --width 200 --transparent true --alpha 0 --tint 0x000000 --height 18 --SetDockType true --SetPartialStrut true &
        exec ck-launch-session xmonad
        ;;
esac
