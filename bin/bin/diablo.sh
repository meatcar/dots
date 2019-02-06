#!/bin/bash

# Run Diablo 2 on other X instance

# Saves you last working path
export LAST_PWD=$PWD 

#Goes to your diablo 2 install path
cd "/home/meatcar/Downloads/Diablo II MXL/"

# runs diablo 2 on a new X session at screen 1, on virtual terminal 9.
#startx /usr/bin/wine 'Game.exe' -3dfx -- :1 vt9 &
#DIABLOPID=$!
#pax11publish -D :1 -e
#wait $DIABLOPID
wine 'Diablo II.exe' -w

cd $LAST_PWD # On diablo exit, returns to your last working path.
exit 0
