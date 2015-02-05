#!/usr/bin/env bash
# Base16 Tomorrow - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#1d1f21"
gsettings set "$SCHEMA" foreground "#c5c8c6"
gsettings set "$SCHEMA" palette "#1d1f21:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#c5c8c6:#969896:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#ffffff"
gsettings set "$SCHEMA" cursor-color "#282a2e"

unset SCHEMA
