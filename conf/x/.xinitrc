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
if [ -d $XDG_CONFIG_HOME/xinit/xinitrc.d ]; then
  for f in $XDG_CONFIG_HOME/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

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
