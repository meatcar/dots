#!/usr/bin/env bash
# Base16 Default - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#181818181818"
gconftool-2 -s -t string /apps/guake/style/font/color "#d8d8d8d8d8d8"
gconftool-2 -s -t string /apps/guake/style/font/palette "#181818181818:#abab46464242:#a1a1b5b56c6c:#f7f7caca8888:#7c7cafafc2c2:#baba8b8bafaf:#8686c1c1b9b9:#d8d8d8d8d8d8:#585858585858:#abab46464242:#a1a1b5b56c6c:#f7f7caca8888:#7c7cafafc2c2:#baba8b8bafaf:#8686c1c1b9b9:#f8f8f8f8f8f8"
