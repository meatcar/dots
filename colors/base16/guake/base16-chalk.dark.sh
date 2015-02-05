#!/usr/bin/env bash
# Base16 Chalk - Guake Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)


gconftool-2 -s -t string /apps/guake/style/background/color "#151515151515"
gconftool-2 -s -t string /apps/guake/style/font/color "#d0d0d0d0d0d0"
gconftool-2 -s -t string /apps/guake/style/font/palette "#151515151515:#fbfb9f9fb1b1:#acacc2c26767:#ddddb2b26f6f:#6f6fc2c2efef:#e1e1a3a3eeee:#1212cfcfc0c0:#d0d0d0d0d0d0:#505050505050:#fbfb9f9fb1b1:#acacc2c26767:#ddddb2b26f6f:#6f6fc2c2efef:#e1e1a3a3eeee:#1212cfcfc0c0:#f5f5f5f5f5f5"
