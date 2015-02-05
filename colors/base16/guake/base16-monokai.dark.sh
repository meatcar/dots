#!/usr/bin/env bash
# Base16 Monokai - Guake Terminal color scheme install script
# Wimer Hazenberg (http://www.monokai.nl)


gconftool-2 -s -t string /apps/guake/style/background/color "#272728282222"
gconftool-2 -s -t string /apps/guake/style/font/color "#f8f8f8f8f2f2"
gconftool-2 -s -t string /apps/guake/style/font/palette "#272728282222:#f9f926267272:#a6a6e2e22e2e:#f4f4bfbf7575:#6666d9d9efef:#aeae8181ffff:#a1a1efefe4e4:#f8f8f8f8f2f2:#757571715e5e:#f9f926267272:#a6a6e2e22e2e:#f4f4bfbf7575:#6666d9d9efef:#aeae8181ffff:#a1a1efefe4e4:#f9f9f8f8f5f5"
