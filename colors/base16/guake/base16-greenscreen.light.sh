#!/usr/bin/env bash
# Base16 Green Screen - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#0000ffff0000"
gconftool-2 -s -t string /apps/guake/style/font/color "#000055550000"
gconftool-2 -s -t string /apps/guake/style/font/palette "#0000ffff0000:#000077770000:#0000bbbb0000:#000077770000:#000099990000:#0000bbbb0000:#000055550000:#0000bbbb0000:#000077770000:#000077770000:#0000bbbb0000:#000077770000:#000099990000:#0000bbbb0000:#000055550000:#000011110000"
