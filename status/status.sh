#!/bin/sh
ICONS="/home/meatcar/dots/status/dzen/xbm8x8"

function netstatus {
    link=`ip link | grep ' UP ' | awk '{print $2}' | tr -d ':'`
    if [ -z "$link" ]; then
        link=down;
    fi
}

function netspeed {
    #
    # displays download / upload speed by checking the /proc/net/dev with
    # 2 second delay
    #
    netstatus
    net=""
    if [ "$link" == "down" ]; then
        net="^fg(red)^i($ICONS/info_01)Network Down^fg()"
        echo "$net"
        exit
    elif [ "$link" == "eth0" ]; then
        net="^fg(orange)^i($ICONS/net_wired.xbm)^fg()"
    else
        # access point name
        ap=`iwconfig "$link" | grep wlan0 | awk '{ print $4 }' | sed -e 's/.*"\(.*\)"/\1/'`
        if [ "$ap" == "extensions." ]; then
            ap="$link"
        fi
        net="^fg(orange)^i($ICONS/wifi_01.xbm) '$ap'^fg()"
    fi

    # get the up/down speed
    old_state=$(cat /proc/net/dev | grep $link)
    sleep 1
    new_state=$(cat /proc/net/dev | grep $link)

    old_dn=`echo ${old_state/*:/} | awk -F " " '{ print $1 }'`
    new_dn=`echo ${new_state/*:/} | awk -F " " '{ print $1 }'`
    dnload=$((${new_dn} - ${old_dn}))

    old_up=`echo ${old_state/*:/} | awk -F " " '{ print $9 }'`
    new_up=`echo ${new_state/*:/} | awk -F " " '{ print $9 }'`
    upload=$((${new_up} - ${old_up}))

    d_speed=$(echo "scale=0;${dnload}/1024" | bc -lq)
    u_speed=$(echo "scale=0;${upload}/1024" | bc -lq)

    down="^fg(green)^i($ICONS/net_down_03.xbm)^fg(orange)${d_speed}K^fg()"
    up="^fg(blue)^i($ICONS/net_up_03.xbm)^fg(orange)${u_speed}K^fg()"

    echo "$net $down$up"
}

function batt {
    perc=`acpi | awk '{print $4}'| tr -d ','`
    state=`acpi | awk '{print $3}'`
    time_rem=`acpi | awk '{print $5}' | cut -d':' -f1,2`
    if [ "$state" = "Discharging," ]; then
        echo "D $perc $time_rem"h
    else
        echo -n "C $perc"
        if [ -n "$time_rem" ]; then
            echo " $time_rem"h
        fi
    fi
}

function music {  ## Print currently playing artist
    toggle="^ca(1, mpc toggle 1>/dev/null)"

    if mpc | grep '\[playing\]' 1>/dev/null; then
        toggle="$toggle^i($ICONS/pause.xbm)^ca()"
    else
        toggle="$toggle^i($ICONS/play.xbm)^ca()"
    fi

    next="^ca(1, mpc next)^i($ICONS/next.xbm)^ca()"
    prev="^ca(1, mpc prev)^i($ICONS/prev.xbm)^ca()"
    echo "^fg(grey70)$prev $toggle $next^fg()"
}

function volume {
    vol_mode=`amixer|head -n5|tail -n1|awk '{print $6}' | tr -d '[]'`
    if [ "$vol_mode" == "off" ]; then
        vol="^fg(grey30)^i($ICONS/spkr_02.xbm)^fg()"
    else
        vol="`amixer|head -n5|tail -n1|awk '{print $5}' | tr -d '[]'`"
        vol="^i($ICONS/spkr_01.xbm) $vol"
    fi
    echo "$vol"
}

function date_time {  
    d=`date +'^fg(grey50)%a %d %b^fg() %H:%M'`
    echo "$d"
}

echo " $(netspeed) $(batt) $(music) $(volume) $(date_time) "
