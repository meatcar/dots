#!/usr/bin/env bash
# Base16 Flat - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#ECECF0F0F1F1"
gconftool-2 -s -t string /apps/guake/style/font/color "#7F7F8C8C8D8D"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ECECF0F0F1F1:#E7E74C4C3C3C:#2E2ECCCC7171:#F1F1C4C40F0F:#34349898DBDB:#9B9B5959B6B6:#1A1ABCBC9C9C:#e0e0e0e0e0e0:#9595A5A5A6A6:#E7E74C4C3C3C:#2E2ECCCC7171:#F1F1C4C40F0F:#34349898DBDB:#9B9B5959B6B6:#1A1ABCBC9C9C:#2C2C3E3E5050"
