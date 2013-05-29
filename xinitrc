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
    aether.denys.me)
        VBoxClient-all &
		sleep 3
        # set resolution of first screen.
        xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
        xrandr --addmode VBOX0 1920x1080_60.00
        xrandr --output VBOX0 --mode 1920x1080_60.00
        # set resolutions of second screen
        xrandr --newmode "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync
        xrandr --addmode VBOX1 1280x1024_60.00
        xrandr --output VBOX1 --mode 1280x1024_60.00
        # move screen over
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
