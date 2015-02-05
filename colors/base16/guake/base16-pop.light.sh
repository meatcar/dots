#!/usr/bin/env bash
# Base16 Pop - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#303030303030"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#ebeb00008a8a:#3737b3b34949:#f8f8caca1212:#0e0e5a5a9494:#b3b31e1e8d8d:#0000aaaabbbb:#d0d0d0d0d0d0:#505050505050:#ebeb00008a8a:#3737b3b34949:#f8f8caca1212:#0e0e5a5a9494:#b3b31e1e8d8d:#0000aaaabbbb:#000000000000"
