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
    gnome-session)
        gnome-session
        ;;
    *)
        ;;
esac


export PATH="$PATH:/home/meatcar/bin"

#######################
# host-dependent setup
#######################
case `hostname` in
    targaryen)
        #compton --config ~/.config/compton/compton.conf -b &
        syndaemon -t -i 1 -d &
        xrandr --dpi 165 &
        udiskie &
        start-pulseaudio-x11 &
        synergyc hyperion&

        if (xrandr | grep 'HDMI1 connected' && iwconfig wlp1s0 | grep 'UofT') > /dev/null
        then
          xrandr --output HDMI1 --mode 1680x1050 --right-of eDP1
        fi
        ;;
    thumbnail)
        xrandr --dpi 120 &
        VBoxClient-all &
        compton --backend glx\
          --blur-background-frame --blur-kern 7x7box\
          -b &

        ;;
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
        # Model M has no super.
        xmodmap -e "keysym Alt_R = Super_L"
        xrandr --output VGA-0 --left-of DVI-I-1 --primary &
        x11vnc -display :0 -rfbauth ~/.x11vnc/passwd -many &>/dev/null &
        systemd --user &
        udiskie &
        ;;
    littlefinger)
        systemd --user &
        numlockx on &
        xrandr --dpi 96 &
        compton --backend glx\
          --blur-background-frame --blur-kern 7x7box\
         -c --shadow-red 1 --shadow-green 1 --shadow-blue 1 \
          -b &

        ;;
esac

# set the cursor
xsetroot -cursor_name left_ptr &
xrdb -merge ~/.Xdefaults &

# set keyboard repeat rate
#xset r rate 190 40

# set capslock to escape.
xmodmap -e "remove lock = Caps_Lock" &
xmodmap -e "keysym Caps_Lock = Escape" &
xbindkeys &

# screensaver
#xscreensaver  -no-splash &

# start mpd, and make sure it's not blaring music
(mpd /home/meatcar/.config/mpd/mpd.conf && mpc pause) &

# rxvt-unicode daemon
urxvtd -q -f -o &

# clipboard manager
#parcellite -n &
xcmenu -dpsc &

dropboxd &
systemd --user &
# wallpaper
eval $(cat ~/.fehbg) &

xautolock  -time 10 -locker 'lock' &


#unclutter -idle 6 -grab -root &

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
    wmii)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        twmnd &

        exec wmii
        ;;
    gnome-session|gnome)
        ;;
    bspwm)
        sxhkd &
        exec bspwm
        ;;
    herbstluftwm)
        exec herbstluftwm
        ;;
    i3|*)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D

	twmnd &
        (sleep 2 && dzenstatus &) &
        exec i3 -V > ~/.i3/log 2>&1
        ;;
esac

