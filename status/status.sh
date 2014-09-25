#!/bin/sh
ICONS="/home/meatcar/dots/status/xbm8x8"
fg='#516DA8'
bg='#D7DCE7'

function netstatus {
    links=`ip link | grep 'BROADCAST' | awk '{print $2}' | tr -d ':'`
    if [ -z "$links" ]; then
        echo down
    else
        echo $links
    fi
}

function netspeed {
    #
    # displays download / upload speed by checking the /proc/net/dev with
    # 2 second delay
    #

    net=""

    links=""
    for link in $(netstatus); do
        if ip link show "$link" | head -n1 | grep -v 'UP' > /dev/null
        then
            net="$net ^bg($bg) ^fg(red)^i($ICONS/info_01) $link ^fg() ^bg()"
            continue
        fi
        links="$links $link"
    done

    # get the up/down speed
    old=""
    for link in $links; do
        old_state=$(cat /proc/net/dev | grep $link)
        old_dn=`echo ${old_state/*:/} | awk -F " " '{ print $1 }'`
        old_up=`echo ${old_state/*:/} | awk -F " " '{ print $9 }'`
        old="$old $old_dn;$old_up"
    done;

    sleep 0.5

    new=""
    for link in $links; do
        new_state=$(cat /proc/net/dev | grep $link)
        new_dn=`echo ${new_state/*:/} | awk -F " " '{ print $1 }'`
        new_up=`echo ${new_state/*:/} | awk -F " " '{ print $9 }'`
        new="$new $new_dn;$new_up"
    done

    count=1
    for link in $links; do
        # calculate speed
        old_state=$(echo $old | awk -F " " "{ print \$$count }")
        old_dn=$(echo $old_state | awk -F ";" '{ print $1 }')
        old_up=$(echo $old_state | awk -F ";" '{ print $2 }')

        new_state=$(echo $new | awk -F " " "{ print \$$count }")
        new_dn=$(echo $new_state | awk -F ";" '{ print $1 }')
        new_up=$(echo $new_state | awk -F ";" '{ print $2 }')

        dnload=$((${new_dn} - ${old_dn}))

        upload=$((${new_up} - ${old_up}))

        d_speed=$(echo "scale=0;${dnload}*2/1024" | bc -lq)
        u_speed=$(echo "scale=0;${upload}*2/1024" | bc -lq)

        
        # Build str

        str="^fg()^i($ICONS/net_wired.xbm) $link^fg()"

        down="^fg()^i($ICONS/net_down_03.xbm)^fg()${d_speed}K"
        up="^fg()^i($ICONS/net_up_03.xbm)^fg()${u_speed}K"

        ip=`ip addr show dev "$link"| grep 'inet '| awk '{print $2}' | sed 's;/.*$;;'`

        str="$str $ip $down $up "
        str="^ca(1,urxvtc -e wicd-curses)$str^ca()"
        str="^bg($bg)$str^bg()"

        net="$net      $str"

        count=$(expr $count + 1)
    done

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
        vol="`amixer|head -n6|tail -n1|awk '{print $5}' | tr -d '[]'`"
        vol="^i($ICONS/spkr_02.xbm) M $vol"
    else
        vol="`amixer|head -n6|tail -n1|awk '{print $5}' | tr -d '[]'`"
        vol="^i($ICONS/spkr_01.xbm) $vol"
    fi
    vol=" $vol "
    vol="^ca(1,urxvtc -e alsamixer)$vol^ca()"
    vol="^ca(2,amixer set 'Master' 'toggle' >/dev/null)$vol^ca()"
    vol="^ca(4,amixer set 'Master' 5%+ >/dev/null)$vol^ca()"
    vol="^ca(5,amixer set 'Master' 5%- >/dev/null)$vol^ca()"
    vol="^bg($bg)$vol^bg()"
    echo "$vol"
}

function date_time {
    d=`date +'^fg(#4d6080)%a %d %b^fg() %l:%M%P'`
    echo "^bg($bg) $d ^bg()"
}

echo "$(netspeed)  $(volume)  $(date_time)"
