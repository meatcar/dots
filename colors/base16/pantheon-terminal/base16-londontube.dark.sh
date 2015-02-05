#!/usr/bin/env bash
# Base16 London Tube - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#231f20"
gsettings set "$SCHEMA" foreground "#d9d8d8"
gsettings set "$SCHEMA" palette "#231f20:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#d9d8d8:#737171:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#ffffff"
gsettings set "$SCHEMA" cursor-color "#1c3f95"

unset SCHEMA
