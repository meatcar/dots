#!/usr/bin/env bash
# Base16 London Tube - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#5a5758"
gsettings set "$SCHEMA" palette "#ffffff:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#d9d8d8:#737171:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#231f20"
gsettings set "$SCHEMA" cursor-color "#231f20"

unset SCHEMA
