#!/usr/bin/env bash
# Base16 Grayscale - Pantheon Terminal color scheme install script
# Alexandre Gavioli (https://github.com/Alexx2/)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f7f7f7"
gsettings set "$SCHEMA" foreground "#464646"
gsettings set "$SCHEMA" palette "#f7f7f7:#7c7c7c:#8e8e8e:#a0a0a0:#686868:#747474:#868686:#b9b9b9:#525252:#7c7c7c:#8e8e8e:#a0a0a0:#686868:#747474:#868686:#101010"
gsettings set "$SCHEMA" cursor-color "#101010"

unset SCHEMA
