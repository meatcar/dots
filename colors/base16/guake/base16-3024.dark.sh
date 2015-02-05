#!/usr/bin/env bash
# Base16 3024 - Guake Terminal color scheme install script
# Jan T. Sott (http://github.com/idleberg)


gconftool-2 -s -t string /apps/guake/style/background/color "#090903030000"
gconftool-2 -s -t string /apps/guake/style/font/color "#a5a5a2a2a2a2"
gconftool-2 -s -t string /apps/guake/style/font/palette "#090903030000:#dbdb2d2d2020:#0101a2a25252:#fdfdeded0202:#0101a0a0e4e4:#a1a16a6a9494:#b5b5e4e4f4f4:#a5a5a2a2a2a2:#5c5c58585555:#dbdb2d2d2020:#0101a2a25252:#fdfdeded0202:#0101a0a0e4e4:#a1a16a6a9494:#b5b5e4e4f4f4:#f7f7f7f7f7f7"
