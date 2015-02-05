#!/usr/bin/env bash
# Base16 Embers - Pantheon Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#16130F"
gsettings set "$SCHEMA" foreground "#A39A90"
gsettings set "$SCHEMA" palette "#16130F:#826D57:#57826D:#6D8257:#6D5782:#82576D:#576D82:#A39A90:#5A5047:#826D57:#57826D:#6D8257:#6D5782:#82576D:#576D82:#DBD6D1"
gsettings set "$SCHEMA" cursor-color "#2C2620"

unset SCHEMA
