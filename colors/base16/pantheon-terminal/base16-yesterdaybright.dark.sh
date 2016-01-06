#!/usr/bin/env bash
# Base16 Yesterday Bright - Pantheon Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#343d46"
gsettings set "$SCHEMA" foreground "#dfe1e8"
gsettings set "$SCHEMA" palette "#343d46:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#dfe1e8:#a7adba:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#ffffff"
gsettings set "$SCHEMA" cursor-color "#4f5b66"

unset SCHEMA
