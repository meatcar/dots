#!/usr/bin/env bash
# Base16 Isotope - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#606060"
gsettings set "$SCHEMA" palette "#ffffff:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#d0d0d0:#808080:#ff0000:#33ff00:#ff0099:#0066ff:#cc00ff:#00ffff:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
