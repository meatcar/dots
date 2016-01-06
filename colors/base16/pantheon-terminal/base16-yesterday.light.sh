#!/usr/bin/env bash
# Base16 Yesterday - Pantheon Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#4d4d4c"
gsettings set "$SCHEMA" palette "#ffffff:#c82829:#718c00:#eab700:#4271ae:#8959a8:#3e999f:#d6d6d6:#969896:#c82829:#718c00:#eab700:#4271ae:#8959a8:#3e999f:#1d1f21"
gsettings set "$SCHEMA" cursor-color "#1d1f21"

unset SCHEMA
