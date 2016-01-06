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
    budgie|budgie-session)
        budgie-session
        ;;
    *)
        ;;
esac

. "$HOME/.login"
genXdefaults


#######################
# host-dependent setup
#######################
case $(hostname) in
    thumbnail)
        xrandr --dpi 120 
        VBoxClient-all &
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
        systemctl --user import-environment
        numlockx on 
        xrandr --dpi 96 
        #compton --backend glx\
          #--blur-background-frame --blur-kern 7x7box\
          #-i 0.9 -f -D 5\
          #-c -C -z -G -o 0.5 \
          #-b &
          #-c --shadow-red 1 --shadow-green 1 --shadow-blue 1 \

        ;;
esac

# set the cursor
xsetroot -cursor_name left_ptr 

# set keyboard repeat rate
#xset r rate 190 40

# set capslock to escape, control when combined with another key.
SPARE_MOD="Hyper_L"
xmodmap -e "remove mod4 = $SPARE_MOD" # hyper_l is mod4 by default
xmodmap -e 'remove Lock = Caps_Lock' 
xmodmap -e "keysym Caps_Lock = $SPARE_MOD"
xmodmap -e "add Control = $SPARE_MOD" 
xcape -e "$SPARE_MOD=Escape"

xbindkeys 

# screensaver
#xscreensaver  -no-splash &

# start mpd, and make sure it's not blaring music
#(mpd /home/meatcar/.config/mpd/mpd.conf && mpc pause) &

# rxvt-unicode daemon
urxvtd -q -f -o &

# clipboard manager
parcellite -n &
xcmenu -dpsc &

#dropbox &
syncthing-gtk &

#rescuetime &

## wallpaper
eval "$(cat ~/.fehbg)" &

xautolock  -time 15 -locker 'lock' &
xset -dpms 
xset s off

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
        dunst &
        startdwm
        ;;
    scrollwm)
        xcompmgr -c -C &
        wmname LG3D
        dunst &
        exec scrollwm
        ;;
    subtle)
        dunst &
        exec subtle
        ;;
    wmii)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        dunst &

        exec wmii
        ;;
    gnome-session|gnome)
        ;;
    budgie|budgie-session)
        ;;
    bspwm)
        sxhkd &
        exec bspwm-session
        ;;
    herbstluftwm)
        exec herbstluftwm
        ;;
    i3|*)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D

        dunst &
        #conky &
        #(sleep 3 && dzenstatus &) &
        exec i3 -V > ~/.i3/log 2>&1
        ;;
esac

