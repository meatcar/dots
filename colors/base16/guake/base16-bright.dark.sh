#!/usr/bin/env bash
# Base16 Bright - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#000000000000"
gconftool-2 -s -t string /apps/guake/style/font/color "#e0e0e0e0e0e0"
gconftool-2 -s -t string /apps/guake/style/font/palette "#000000000000:#fbfb01012020:#a1a1c6c65959:#fdfda3a33131:#6f6fb3b3d2d2:#d3d38181c3c3:#7676c7c7b7b7:#e0e0e0e0e0e0:#b0b0b0b0b0b0:#fbfb01012020:#a1a1c6c65959:#fdfda3a33131:#6f6fb3b3d2d2:#d3d38181c3c3:#7676c7c7b7b7:#ffffffffffff"
