#!/usr/bin/env bash
# Base16 Seti UI - Pantheon Terminal color scheme install script
# 
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#3B758C"
gsettings set "$SCHEMA" palette "#ffffff:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#d6d6d6:#41535B:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#151718"
gsettings set "$SCHEMA" cursor-color "#151718"

unset SCHEMA
