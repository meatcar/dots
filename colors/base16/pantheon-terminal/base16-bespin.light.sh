#!/usr/bin/env bash
# Base16 Bespin - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#baae9e"
gsettings set "$SCHEMA" foreground "#5e5d5c"
gsettings set "$SCHEMA" palette "#baae9e:#cf6a4c:#54be0d:#f9ee98:#5ea6ea:#9b859d:#afc4db:#8a8986:#666666:#cf6a4c:#54be0d:#f9ee98:#5ea6ea:#9b859d:#afc4db:#28211c"
gsettings set "$SCHEMA" cursor-color "#28211c"

unset SCHEMA
