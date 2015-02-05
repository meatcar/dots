#!/usr/bin/env bash
# Base16 harmonic16 - Pantheon Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#0b1c2c"
gsettings set "$SCHEMA" foreground "#cbd6e2"
gsettings set "$SCHEMA" palette "#0b1c2c:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#cbd6e2:#627e99:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#f7f9fb"
gsettings set "$SCHEMA" cursor-color "#223b54"

unset SCHEMA
