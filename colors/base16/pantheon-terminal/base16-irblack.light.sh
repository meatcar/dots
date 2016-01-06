#!/usr/bin/env bash
# Base16 IR Black - Pantheon Terminal color scheme install script
# Timothée Poisot (http://timotheepoisot.fr)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#fdfbee"
gsettings set "$SCHEMA" foreground "#484844"
gsettings set "$SCHEMA" palette "#fdfbee:#ff6c60:#a8ff60:#ffffb6:#96cbfe:#ff73fd:#c6c5fe:#b5b3aa:#6c6c66:#ff6c60:#a8ff60:#ffffb6:#96cbfe:#ff73fd:#c6c5fe:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
