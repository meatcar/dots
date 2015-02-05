#!/usr/bin/env bash
# Base16 London Tube - Guake Terminal color scheme install script
# Jan T. Sott


gconftool-2 -s -t string /apps/guake/style/background/color "#23231f1f2020"
gconftool-2 -s -t string /apps/guake/style/font/color "#d9d9d8d8d8d8"
gconftool-2 -s -t string /apps/guake/style/font/palette "#23231f1f2020:#eeee2e2e2424:#000085853e3e:#ffffd2d20404:#00009d9ddcdc:#989800005d5d:#8585cecebcbc:#d9d9d8d8d8d8:#737371717171:#eeee2e2e2424:#000085853e3e:#ffffd2d20404:#00009d9ddcdc:#989800005d5d:#8585cecebcbc:#ffffffffffff"
