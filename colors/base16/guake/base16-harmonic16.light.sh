#!/usr/bin/env bash
# Base16 harmonic16 - Guake Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)


gconftool-2 -s -t string /apps/guake/style/background/color "#f7f7f9f9fbfb"
gconftool-2 -s -t string /apps/guake/style/font/color "#40405c5c7979"
gconftool-2 -s -t string /apps/guake/style/font/palette "#f7f7f9f9fbfb:#bfbf8b8b5656:#5656bfbf8b8b:#8b8bbfbf5656:#8b8b5656bfbf:#bfbf56568b8b:#56568b8bbfbf:#cbcbd6d6e2e2:#62627e7e9999:#bfbf8b8b5656:#5656bfbf8b8b:#8b8bbfbf5656:#8b8b5656bfbf:#bfbf56568b8b:#56568b8bbfbf:#0b0b1c1c2c2c"
