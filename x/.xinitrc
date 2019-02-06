#!/bin/sh
#
# ~/.xinitrc

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

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
        x11vnc -display :0 -rfbauth ~/.x11vnc/passwd -many >/dev/null 2>&1 &
        systemd --user &
        udiskie &
        ;;
    littlefinger)
        numlockx on
        xrandr --dpi 96
        echo 'Xft.dpi: 96' | xrdb -merge
        blueman-applet

        ;;
        
    bronn)
        xrandr --dpi 144 
        echo 'Xft.dpi: 144' | xrdb -merge
        #touchegg >/dev/null 2>&1 &
        xkbcomp \
          -i "$(xinput | grep 'Surface Pro 3/4 Buttons' | sed 's/\s/\n/g' | grep id | sed 's/id=//')" \
          .config/sp3buttons.xkb "$DISPLAY" &
        ;;
esac

systemctl --user import-environment

capslock-to-escape &

xbindkeys &

## wallpaper
#eval "$(cat ~/.fehbg)" &
wallp $(wallp)

xautolock  -time 10 -locker 'lock' &

#####################
# WM-dependent setup
#####################
echo "$@" > ~/xinit-args
case $(basename "$1") in
    xmonad)
        dzconky &
        trayer --edge bottom --align right --widthtype pixel --width 200 \
            --transparent true --alpha 0 --tint 0x000000 --height 18 \
            --SetDockType true --SetPartialStrut true &
        xmonad
        ;;
    openbox|openbox-session)
        tint2 &
        exec openbox
        ;;
    dwm)
        xcompmgr -c -C &
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        startdwm
        ;;
    scrollwm)
        wmname LG3D
        exec scrollwm
        ;;
    subtle)
        exec subtle
        ;;
    wmii)
        # Set the wm name to somethign Java recognizes.
        wmname LG3D
        exec wmii
        ;;
    gnome-session|gnome)
        exec gnome-session
        ;;
    budgie|budgie-session|budgie-desktop)
        #export XDG_CURRENT_DESKTOP=Budgie:GNOME
        exec budgie-desktop
        ;;
    bspwm)
        wmname LG3D

        exec bspwm
        ;;
    herbstluftwm)
        wmname LG3D

        exec herbstluftwm --locked
        ;;
    i3)
        # Set the wm name to something Java recognizes.
        wmname LG3D

        exec i3 -V > ~/.i3/log 2>&1
        ;;
    wmaker|windowmaker)
        exec wmaker
        ;;
    /usr/bin/startkde|kde|plasma)
        exec startkde
        ;;
    compiz)
        fusion-icon &
        exec cairo-dock
        ;;
    lxde)
        wmname LG3D

        exec startlxd
        ;;
esac
