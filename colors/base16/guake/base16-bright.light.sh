#!/usr/bin/env bash
# Base16 Bright - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#505050505050"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#fbfb01012020:#a1a1c6c65959:#fdfda3a33131:#6f6fb3b3d2d2:#d3d38181c3c3:#7676c7c7b7b7:#e0e0e0e0e0e0:#b0b0b0b0b0b0:#fbfb01012020:#a1a1c6c65959:#fdfda3a33131:#6f6fb3b3d2d2:#d3d38181c3c3:#7676c7c7b7b7:#000000000000"
