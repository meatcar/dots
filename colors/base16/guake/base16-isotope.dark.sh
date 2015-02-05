#!/usr/bin/env bash
# Base16 Isotope - Guake Terminal color scheme install script
# Jan T. Sott


gconftool-2 -s -t string /apps/guake/style/background/color "#000000000000"
gconftool-2 -s -t string /apps/guake/style/font/color "#d0d0d0d0d0d0"
gconftool-2 -s -t string /apps/guake/style/font/palette "#000000000000:#ffff00000000:#3333ffff0000:#ffff00009999:#00006666ffff:#cccc0000ffff:#0000ffffffff:#d0d0d0d0d0d0:#808080808080:#ffff00000000:#3333ffff0000:#ffff00009999:#00006666ffff:#cccc0000ffff:#0000ffffffff:#ffffffffffff"
