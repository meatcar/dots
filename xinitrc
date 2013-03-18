#!/bin/sh
#
# ~/.xinitrc

# Gnome takes care of itself. Just run it by itself.
case $1 in
    gnome)
        gnome-session
        ;;
    *)
        ;;
esac


# set the cursor
xsetroot -cursor_name left_ptr
xrdb ~/.Xdefaults &

# set capslock to escape.
xmodmap -e "remove lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Escape"

# screensaver
xscreensaver  -no-splash &

# start mpd, and make sure it's not blaring music
(mpd /home/meatcar/.config/mpd/mpd.conf && mpc pause) &

# rxvt-unicode daemon
urxvtd &

# clipboard manager
parcellite &

dropboxd &
systemd --user &
# wallpaper
eval $(cat ~/.fehbg) &

xautolock  -time 10 -locker slock &

#######################
# host-dependent setup
#######################
case `hostname` in
    aether)
        VBoxClient-all &
		sleep 3
        xrandr --output VBOX1 --right-of VBOX0
        ;;
    viafoura.denys.me)
        xrandr --output VGA-0 --left-of DVI-I-1 --primary &
        x11vnc -display :0 -rfbauth ~/.x11vnc/passwd -many &>/dev/null &
        ;;
    *)
        synergyc hyperion&
        ;;
esac 


#####################
# WM-dependent setup
#####################
case $1 in
    kde)
        exec startkde
        ;;
    xmonad)
        dzconky &
        trayer --edge bottom --align right --widthtype pixel --width 200 \
            --transparent true --alpha 0 --tint 0x000000 --height 18 \
            --SetDockType true --SetPartialStrut true &
        xmonad
        ;;
    openbox)
        wicd-gtk --tray >/dev/null 2>&1 &
        xcompmgr -c -C&
        tint2 &
        exec openbox-session
        ;;
    wmii)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        
        exec wmii
        ;;
    i3)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D

        exec i3
        ;;
    dwm)
        xcompmgr -c -C &
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        
        #dwm-status &
        dzenstatus &
        twmnd &
        startdwm
        ;;
esac
