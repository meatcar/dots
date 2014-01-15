#!/bin/bash

cd "/home/meatcar/Dropbox/Pics/webcam"

mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -frames 1 -vf screenshot -vo "png:z=9:prefix=`date +%s`"
