#!/usr/bin/env bash
# Base16 Hopscotch - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#322931"
gsettings set "$SCHEMA" foreground "#b9b5b8"
gsettings set "$SCHEMA" palette "#322931:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#b9b5b8:#797379:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#ffffff"
gsettings set "$SCHEMA" cursor-color "#433b42"

unset SCHEMA
