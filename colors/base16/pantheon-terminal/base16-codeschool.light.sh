#!/usr/bin/env bash
# Base16 Codeschool - Pantheon Terminal color scheme install script
# brettof86
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#b5d8f6"
gsettings set "$SCHEMA" foreground "#2a343a"
gsettings set "$SCHEMA" palette "#b5d8f6:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#9ea7a6:#3f4944:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#232c31"
gsettings set "$SCHEMA" cursor-color "#232c31"

unset SCHEMA
