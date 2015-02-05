#!/usr/bin/env bash
# Base16 Atelier Forest - Pantheon Terminal color scheme install script
# Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/forest)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f1efee"
gsettings set "$SCHEMA" foreground "#68615e"
gsettings set "$SCHEMA" palette "#f1efee:#f22c40:#5ab738:#d5911a:#407ee7:#6666ea:#00ad9c:#a8a19f:#766e6b:#f22c40:#5ab738:#d5911a:#407ee7:#6666ea:#00ad9c:#1b1918"
gsettings set "$SCHEMA" cursor-color "#1b1918"

unset SCHEMA
