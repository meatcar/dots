#!/usr/bin/env bash
# Base16 Bespin - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#28211c"
gsettings set "$SCHEMA" foreground "#8a8986"
gsettings set "$SCHEMA" palette "#28211c:#cf6a4c:#54be0d:#f9ee98:#5ea6ea:#9b859d:#afc4db:#8a8986:#666666:#cf6a4c:#54be0d:#f9ee98:#5ea6ea:#9b859d:#afc4db:#baae9e"
gsettings set "$SCHEMA" cursor-color "#36312e"

unset SCHEMA
