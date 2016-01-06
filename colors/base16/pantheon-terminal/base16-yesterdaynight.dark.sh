#!/usr/bin/env bash
# Base16 Yesterday Night - Pantheon Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#343d46"
gsettings set "$SCHEMA" foreground "#dfe1e8"
gsettings set "$SCHEMA" palette "#343d46:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#dfe1e8:#a7adba:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#ffffff"
gsettings set "$SCHEMA" cursor-color "#4f5b66"

unset SCHEMA
