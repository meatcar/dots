#!/bin/sh
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
    if [ "$link" == "down" ]; then
        echo -e "Network Down"
        exit 1
    fi

    # access point name
    ap=`iwconfig "$link" | grep wlan0 | awk '{ print $4 }' | sed -e 's/.*"\(.*\)"/\1/'`
    if [ "$ap" == "extensions." ]; then
        ap="$link"
    fi

    old_state=$(cat /proc/net/dev | grep ${link})
    sleep 1
    new_state=$(cat /proc/net/dev | grep ${link})

    old_dn=`echo ${old_state/*:/} | awk -F " " '{ print $1 }'`
    new_dn=`echo ${new_state/*:/} | awk -F " " '{ print $1 }'`
    dnload=$((${new_dn} - ${old_dn}))

    old_up=`echo ${old_state/*:/} | awk -F " " '{ print $9 }'`
    new_up=`echo ${new_state/*:/} | awk -F " " '{ print $9 }'`
    upload=$((${new_up} - ${old_up}))

    d_speed=$(echo "scale=0;${dnload}/1024" | bc -lq)
    u_speed=$(echo "scale=0;${upload}/1024" | bc -lq)

    echo -e "'$ap'" D ${d_speed}K/s U ${u_speed}K/s
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
	tmp=`mpc |grep "\[playing\]" | wc -l`
	if [ "$tmp" == "1" ]; then
		vis=`mpc current | awk -F "-" '{print $1}'`
		echo ":: $vis"
	fi
}

function volume {
	vol_mode=`amixer|head -n5|tail -n1|awk '{print $6}' | tr -d '[]'`
    if [ "$vol_mode" == "off" ]; then
        vol='Mute'
    else
        vol="`amixer|head -n5|tail -n1|awk '{print $5}' | tr -d '[]'`"
    fi
    echo "V $vol"
}

function date_time {  # Print Date, Time. Highlight it all if volume is muted
	d=`date +'%a %d %b %H:%M'`
    echo "$d"
}

if [ $# -eq 0 ]; then
    echo " $(netspeed) :: $(batt) :: $(volume) :: $(date_time) "
else
    echo -e " $(netspeed) :: $(batt) :: $(volume) :: \x02$1\x01 "
fi
