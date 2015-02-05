#!/usr/bin/env bash
# Base16 Pop - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#000000000000"
gconftool-2 -s -t string /apps/guake/style/font/color "#d0d0d0d0d0d0"
gconftool-2 -s -t string /apps/guake/style/font/palette "#000000000000:#ebeb00008a8a:#3737b3b34949:#f8f8caca1212:#0e0e5a5a9494:#b3b31e1e8d8d:#0000aaaabbbb:#d0d0d0d0d0d0:#505050505050:#ebeb00008a8a:#3737b3b34949:#f8f8caca1212:#0e0e5a5a9494:#b3b31e1e8d8d:#0000aaaabbbb:#ffffffffffff"
