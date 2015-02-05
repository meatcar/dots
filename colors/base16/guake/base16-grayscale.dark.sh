#!/usr/bin/env bash
# Base16 Grayscale - Guake Terminal color scheme install script
# Alexandre Gavioli (https://github.com/Alexx2/)


gconftool-2 -s -t string /apps/guake/style/background/color "#101010101010"
gconftool-2 -s -t string /apps/guake/style/font/color "#b9b9b9b9b9b9"
gconftool-2 -s -t string /apps/guake/style/font/palette "#101010101010:#7c7c7c7c7c7c:#8e8e8e8e8e8e:#a0a0a0a0a0a0:#686868686868:#747474747474:#868686868686:#b9b9b9b9b9b9:#525252525252:#7c7c7c7c7c7c:#8e8e8e8e8e8e:#a0a0a0a0a0a0:#686868686868:#747474747474:#868686868686:#f7f7f7f7f7f7"
