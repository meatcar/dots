#!/usr/bin/env bash
# Base16 Macintosh - Guake Terminal color scheme install script
# Rebecca Bettencourt (http://www.kreativekorp.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#404040404040"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#dddd09090707:#1f1fb7b71414:#fbfbf3f30505:#00000000d3d3:#47470000a5a5:#0202ababeaea:#c0c0c0c0c0c0:#808080808080:#dddd09090707:#1f1fb7b71414:#fbfbf3f30505:#00000000d3d3:#47470000a5a5:#0202ababeaea:#000000000000"
