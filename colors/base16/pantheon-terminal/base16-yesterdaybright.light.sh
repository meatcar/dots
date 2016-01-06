#!/usr/bin/env bash
# Base16 Yesterday Bright - Pantheon Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#65737e"
gsettings set "$SCHEMA" palette "#ffffff:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#dfe1e8:#a7adba:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#343d46"
gsettings set "$SCHEMA" cursor-color "#343d46"

unset SCHEMA
