#!/bin/sh
# note: notify-send is required, see libnotify-bin

# XXX do not notify if notification source has focus

delay="2000"

read -r line
summary="$line"
read -r line
msg="$line"
read -r line

if [ "$line" = "" ] && [ "$summary" != "" ]; then
  # Change the icon
  #[ -x "$(which notify-send)" ] && notify-send -i gtk-dialog-info -t "$delay" -- "$summary" "$msg"
  [ -x "$(which notify-send)" ] && notify-send -i notification-message-im -t "$delay" -- "$summary" "$msg"
fi
