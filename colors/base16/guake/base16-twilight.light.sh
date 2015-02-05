#!/usr/bin/env bash
# Base16 Twilight - Guake Terminal color scheme install script
# David Hart (http://hart-dev.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#46464b4b5050"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#cfcf6a6a4c4c:#8f8f9d9d6a6a:#f9f9eeee9898:#75758787a6a6:#9b9b85859d9d:#afafc4c4dbdb:#a7a7a7a7a7a7:#5f5f5a5a6060:#cfcf6a6a4c4c:#8f8f9d9d6a6a:#f9f9eeee9898:#75758787a6a6:#9b9b85859d9d:#afafc4c4dbdb:#1e1e1e1e1e1e"
