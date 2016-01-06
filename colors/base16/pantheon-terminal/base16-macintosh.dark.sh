#!/usr/bin/env bash
# Base16 Macintosh - Pantheon Terminal color scheme install script
# Rebecca Bettencourt (http://www.kreativekorp.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#000000"
gsettings set "$SCHEMA" foreground "#c0c0c0"
gsettings set "$SCHEMA" palette "#000000:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#c0c0c0:#808080:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#ffffff"
gsettings set "$SCHEMA" cursor-color "#404040"

unset SCHEMA
