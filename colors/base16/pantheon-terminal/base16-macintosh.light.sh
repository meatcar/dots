#!/usr/bin/env bash
# Base16 Macintosh - Pantheon Terminal color scheme install script
# Rebecca Bettencourt (http://www.kreativekorp.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#404040"
gsettings set "$SCHEMA" palette "#ffffff:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#c0c0c0:#808080:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
