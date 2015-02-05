#!/usr/bin/env bash
# Base16 Hopscotch - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#5c545b"
gsettings set "$SCHEMA" palette "#ffffff:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#b9b5b8:#797379:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#322931"
gsettings set "$SCHEMA" cursor-color "#322931"

unset SCHEMA
