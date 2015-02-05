#!/usr/bin/env bash
# Base16 Brewer - Pantheon Terminal color scheme install script
# Timothée Poisot (http://github.com/tpoisot)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#0c0d0e"
gsettings set "$SCHEMA" foreground "#b7b8b9"
gsettings set "$SCHEMA" palette "#0c0d0e:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#b7b8b9:#737475:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#fcfdfe"
gsettings set "$SCHEMA" cursor-color "#2e2f30"

unset SCHEMA
