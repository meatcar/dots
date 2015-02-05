#!/usr/bin/env bash
# Base16 harmonic16 - Pantheon Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f7f9fb"
gsettings set "$SCHEMA" foreground "#405c79"
gsettings set "$SCHEMA" palette "#f7f9fb:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#cbd6e2:#627e99:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#0b1c2c"
gsettings set "$SCHEMA" cursor-color "#0b1c2c"

unset SCHEMA
