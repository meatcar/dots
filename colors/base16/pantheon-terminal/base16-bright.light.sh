#!/usr/bin/env bash
# Base16 Bright - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#505050"
gsettings set "$SCHEMA" palette "#ffffff:#fb0120:#a1c659:#fda331:#6fb3d2:#d381c3:#76c7b7:#e0e0e0:#b0b0b0:#fb0120:#a1c659:#fda331:#6fb3d2:#d381c3:#76c7b7:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
