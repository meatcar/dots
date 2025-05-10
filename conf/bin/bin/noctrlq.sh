#!/bin/bash
# from https://github.com/sasawat/firefox-ctrl-q-workaround/

W=$(xdotool getactivewindow)
S1=$(xprop -id "${W}" | awk '/WM_CLASS/{print $4}')
if [ "$S1" != '"Firefox"' ]; then
  xvkbd -xsendevent -text "\Cq"
#	echo $S1
fi
