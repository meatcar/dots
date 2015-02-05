#!/usr/bin/env bash
# Base16 Solarized - Guake Terminal color scheme install script
# Ethan Schoonover (http://ethanschoonover.com/solarized)


gconftool-2 -s -t string /apps/guake/style/background/color "#fdfdf6f6e3e3"
gconftool-2 -s -t string /apps/guake/style/font/color "#58586e6e7575"
gconftool-2 -s -t string /apps/guake/style/font/palette "#fdfdf6f6e3e3:#dcdc32322f2f:#858599990000:#b5b589890000:#26268b8bd2d2:#6c6c7171c4c4:#2a2aa1a19898:#9393a1a1a1a1:#65657b7b8383:#dcdc32322f2f:#858599990000:#b5b589890000:#26268b8bd2d2:#6c6c7171c4c4:#2a2aa1a19898:#00002b2b3636"
