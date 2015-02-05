#!/usr/bin/env bash
# Base16 Grayscale - Guake Terminal color scheme install script
# Alexandre Gavioli (https://github.com/Alexx2/)


gconftool-2 -s -t string /apps/guake/style/background/color "#f7f7f7f7f7f7"
gconftool-2 -s -t string /apps/guake/style/font/color "#464646464646"
gconftool-2 -s -t string /apps/guake/style/font/palette "#f7f7f7f7f7f7:#7c7c7c7c7c7c:#8e8e8e8e8e8e:#a0a0a0a0a0a0:#686868686868:#747474747474:#868686868686:#b9b9b9b9b9b9:#525252525252:#7c7c7c7c7c7c:#8e8e8e8e8e8e:#a0a0a0a0a0a0:#686868686868:#747474747474:#868686868686:#101010101010"
