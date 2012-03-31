#!/bin/bash

cd "/mnt/win/Valhalla/Multimedia/Pictures/Camera/Webcam/timeline/"

fswebcam --no-banner --no-shadow --no-title --no-subtitle -r '1024x768' --jpeg 95 --save "`date`.jpg"
