#!/usr/bin/env bash
# Base16 Codeschool - Guake Terminal color scheme install script
# brettof86


gconftool-2 -s -t string /apps/guake/style/background/color "#23232c2c3131"
gconftool-2 -s -t string /apps/guake/style/font/color "#9e9ea7a7a6a6"
gconftool-2 -s -t string /apps/guake/style/font/palette "#23232c2c3131:#2a2a54549191:#232379798686:#a0a03b3b1e1e:#48484d4d7979:#c5c598982020:#b0b02f2f3030:#9e9ea7a7a6a6:#3f3f49494444:#2a2a54549191:#232379798686:#a0a03b3b1e1e:#48484d4d7979:#c5c598982020:#b0b02f2f3030:#b5b5d8d8f6f6"
