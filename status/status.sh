#!/bin/sh
ICONS="/home/meatcar/dots/status/xbm8x8"
fg='#3B95BD'
bg='#001E28'

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
    dev="wlp1s0"
    net=""
    if [ "$link" == "down" ]; then
        net="^bg($bg) ^fg(red)^i($ICONS/info_01)Network Down^fg() ^bg()"
        echo "^ca(1, urxvtc -e wicd-curses)$net^ca()"
        exit
    elif [ "$link" == "eth0" ]; then
        net="^fg()^i($ICONS/net_wired.xbm)^fg()"
    else
        # access point name
        ap=`iwconfig "$link" | grep "$dev"| awk '{ print $4 }' | sed -e 's/.*"\(.*\)"/\1/'`
        if [ "$ap" == "extensions." ]; then
            ap="$link"
        fi
        net="^fg()^i($ICONS/wifi_01.xbm)^fg() '$ap'"
    fi

    ip=`ip addr show dev "$dev"| grep 'inet '| awk '{print $2}' | sed 's;/.*$;;'`

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

    down="^fg()^i($ICONS/net_down_03.xbm)^fg()${d_speed}K"
    up="^fg()^i($ICONS/net_up_03.xbm)^fg()${u_speed}K"

    net=" $net $ip $down $up "
    net="^ca(1,urxvtc -e wicd-curses)$net^ca()"
    net="^bg($bg)$net^bg()"

    echo "$net"
}

function backlight() {
    light=`xbacklight | sed 's/\.\?0*$//g'`
    light="^i($ICONS/full.xbm) $light%"
    light="^bg($bg) $light ^bg()"

    echo "$light"
}

function batt {
    perc=`acpi | awk '{print $4}'| tr -d ',%'`
    state=`acpi | awk '{print $3}'`
    time_rem=`acpi | awk '{print $5}' | cut -d':' -f1,2`
    if [ "$state" = "Discharging," ]; then
        if  test "( $perc -le 100 ) -a ( $perc -gt 30 )"; then
            icon="^fg()^i($ICONS/bat_full_02.xbm)"
        elif test "( $perc -le 30 ) -a ( $perc -gt 10 )"; then
            icon="^fg()^i($ICONS/bat_low_02.xbm)"
        else
            icon="^fg()^i($ICONS/bat_empty_02.xbm)"
        fi
        echo "^bg($bg) $icon^fg() $perc% $time_rem ^bg()"
    else
        icon="^i($ICONS/ac_01.xbm)"
        if [ -n "$time_rem" ]; then
            time_rem=" $time_rem"
        fi
        echo "^bg($bg) ^fg()$icon^fg() $perc%$time_rem ^bg()"
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
    phones="^ca(1,urxvtc -e ncmpcpp)^i($ICONS/phones.xbm)^ca()"
    echo "^bg($bg) $phones $prev|$toggle|$next ^bg()"
}

function volume {
    vol_mode=`amixer|head -n6|tail -n1|awk '{print $6}' | tr -d '[]'`
    if [ "$vol_mode" == "off" ]; then
        vol="^fg(grey30)^i($ICONS/spkr_02.xbm)^fg()"
    else
        vol="`amixer|head -n6|tail -n1|awk '{print $5}' | tr -d '[]'`"
        vol="^i($ICONS/spkr_01.xbm) $vol"
    fi
    vol=" $vol "
    vol="^ca(1,urxvtc -e alsamixer)$vol^ca()"
    vol="^ca(2,amixer set 'Master' 'toggle')$vol^ca()"
    vol="^ca(4,amixer set 'Master' 5%+ )$vol^ca()"
    vol="^ca(5,amixer set 'Master' 5%- )$vol^ca()"
    vol="^bg($bg)$vol^bg()"
    echo "$vol"
}

function date_time {
    d=`date +'^fg(#4d6080)%a %d %b^fg() %H:%M'`
    echo "^bg($bg) $d ^bg()"
}

echo "$(netspeed) $(batt) $(backlight) $(volume) $(date_time)"
