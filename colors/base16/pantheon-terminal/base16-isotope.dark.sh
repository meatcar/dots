#!/usr/bin/env bash
# Base16 Isotope - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#000000"
gsettings set "$SCHEMA" foreground "#d0d0d0"
gsettings set "$SCHEMA" palette "#000000:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#d0d0d0:#808080:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#ffffff"
gsettings set "$SCHEMA" cursor-color "#404040"

unset SCHEMA
