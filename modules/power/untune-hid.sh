#!/bin/sh

HIDDEVICES=$(find /sys/bus/usb/drivers/usbhid -maxdepth 1 | grep -oE '^[0-9]+-[0-9\.]+' | sort -u)
for i in $HIDDEVICES; do
  printf "Enabling %s" "$(cat /sys/bus/usb/devices/"$i"/product)"
  echo 'on' >/sys/bus/usb/devices/"$i"/power/control
done
