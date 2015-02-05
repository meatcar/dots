#!/usr/bin/env bash
# Base16 Brewer - Pantheon Terminal color scheme install script
# Timothée Poisot (http://github.com/tpoisot)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#fcfdfe"
gsettings set "$SCHEMA" foreground "#515253"
gsettings set "$SCHEMA" palette "#fcfdfe:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#b7b8b9:#737475:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#0c0d0e"
gsettings set "$SCHEMA" cursor-color "#0c0d0e"

unset SCHEMA
