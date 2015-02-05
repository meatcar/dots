#!/usr/bin/env bash
# Base16 Tomorrow - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#37373b3b4141"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#c5c5c8c8c6c6:#969698989696:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#1d1d1f1f2121"
