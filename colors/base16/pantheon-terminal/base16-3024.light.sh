#!/usr/bin/env bash
# Base16 3024 - Pantheon Terminal color scheme install script
# Jan T. Sott (http://github.com/idleberg)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f7f7f7"
gsettings set "$SCHEMA" foreground "#4a4543"
gsettings set "$SCHEMA" palette "#f7f7f7:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#a5a2a2:#5c5855:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#090300"
gsettings set "$SCHEMA" cursor-color "#090300"

unset SCHEMA
