#!/usr/bin/env bash
# Base16 IR Black - Guake Terminal color scheme install script
# Timothée Poisot (http://timotheepoisot.fr)


gconftool-2 -s -t string /apps/guake/style/background/color "#000000000000"
gconftool-2 -s -t string /apps/guake/style/font/color "#b5b5b3b3aaaa"
gconftool-2 -s -t string /apps/guake/style/font/palette "#000000000000:#ffff6c6c6060:#a8a8ffff6060:#ffffffffb6b6:#9696cbcbfefe:#ffff7373fdfd:#c6c6c5c5fefe:#b5b5b3b3aaaa:#6c6c6c6c6666:#ffff6c6c6060:#a8a8ffff6060:#ffffffffb6b6:#9696cbcbfefe:#ffff7373fdfd:#c6c6c5c5fefe:#fdfdfbfbeeee"
