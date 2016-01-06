#!/usr/bin/env bash
# Base16 Yesterday Night - Pantheon Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#65737e"
gsettings set "$SCHEMA" palette "#ffffff:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#dfe1e8:#a7adba:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#343d46"
gsettings set "$SCHEMA" cursor-color "#343d46"

unset SCHEMA
