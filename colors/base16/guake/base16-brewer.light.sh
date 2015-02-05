#!/usr/bin/env bash
# Base16 Brewer - Guake Terminal color scheme install script
# Timothée Poisot (http://github.com/tpoisot)


gconftool-2 -s -t string /apps/guake/style/background/color "#fcfcfdfdfefe"
gconftool-2 -s -t string /apps/guake/style/font/color "#515152525353"
gconftool-2 -s -t string /apps/guake/style/font/palette "#fcfcfdfdfefe:#e3e31a1a1c1c:#3131a3a35454:#dcdca0a06060:#31318282bdbd:#75756b6bb1b1:#8080b1b1d3d3:#b7b7b8b8b9b9:#737374747575:#e3e31a1a1c1c:#3131a3a35454:#dcdca0a06060:#31318282bdbd:#75756b6bb1b1:#8080b1b1d3d3:#0c0c0d0d0e0e"
