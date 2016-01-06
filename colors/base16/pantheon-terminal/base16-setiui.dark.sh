#!/usr/bin/env bash
# Base16 Seti UI - Pantheon Terminal color scheme install script
# 
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#151718"
gsettings set "$SCHEMA" foreground "#d6d6d6"
gsettings set "$SCHEMA" palette "#151718:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#d6d6d6:#41535B:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#ffffff"
gsettings set "$SCHEMA" cursor-color "#8ec43d"

unset SCHEMA
