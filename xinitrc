#!/bin/sh
#
# ~/.xinitrc

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

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
parcellite -n &

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
        # Model M has no super.
        xmodmap -e "keysym Alt_R = Super_L"
        xrandr --output VGA-0 --left-of DVI-I-1 --primary &
        x11vnc -display :0 -rfbauth ~/.x11vnc/passwd -many &>/dev/null &
        systemd --user &
        udiskie &
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
    scrollwm) 
        xcompmgr -c -C &
        wmname LG3D
        twmnd &
        exec scrollwm
        ;;
    subtle)
        twmnd &
        exec subtle
        ;;
    wmii|*)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        twmnd &
        
        exec wmii
        ;;
esac
