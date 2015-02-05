#!/usr/bin/env bash
# Base16 Bright - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#000000"
gsettings set "$SCHEMA" foreground "#e0e0e0"
gsettings set "$SCHEMA" palette "#000000:#fb0120:#a1c659:#fda331:#6fb3d2:#d381c3:#76c7b7:#e0e0e0:#b0b0b0:#fb0120:#a1c659:#fda331:#6fb3d2:#d381c3:#76c7b7:#ffffff"
gsettings set "$SCHEMA" cursor-color "#303030"

unset SCHEMA
