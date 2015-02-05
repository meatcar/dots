#!/usr/bin/env bash
# Base16 shapeshifter - Guake Terminal color scheme install script
# Tyler Benziger (http://tybenz.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#f9f9f9f9f9f9"
gconftool-2 -s -t string /apps/guake/style/font/color "#101020201515"
gconftool-2 -s -t string /apps/guake/style/font/palette "#f9f9f9f9f9f9:#e9e92f2f2f2f:#0e0ed8d83939:#dddddddd1313:#3b3b4848e3e3:#f9f99696e2e2:#2323ededdada:#abababababab:#343434343434:#e9e92f2f2f2f:#0e0ed8d83939:#dddddddd1313:#3b3b4848e3e3:#f9f99696e2e2:#2323ededdada:#000000000000"
