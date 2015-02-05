#!/usr/bin/env bash
# Base16 3024 - Pantheon Terminal color scheme install script
# Jan T. Sott (http://github.com/idleberg)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#090300"
gsettings set "$SCHEMA" foreground "#a5a2a2"
gsettings set "$SCHEMA" palette "#090300:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#a5a2a2:#5c5855:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#f7f7f7"
gsettings set "$SCHEMA" cursor-color "#3a3432"

unset SCHEMA
