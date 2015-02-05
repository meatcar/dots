#!/usr/bin/env bash
# Base16 Twilight - Pantheon Terminal color scheme install script
# David Hart (http://hart-dev.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#464b50"
gsettings set "$SCHEMA" palette "#ffffff:#cf6a4c:#8f9d6a:#f9ee98:#7587a6:#9b859d:#afc4db:#a7a7a7:#5f5a60:#cf6a4c:#8f9d6a:#f9ee98:#7587a6:#9b859d:#afc4db:#1e1e1e"
gsettings set "$SCHEMA" cursor-color "#1e1e1e"

unset SCHEMA
