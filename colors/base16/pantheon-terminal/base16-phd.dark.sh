#!/usr/bin/env bash
# Base16 PhD - Pantheon Terminal color scheme install script
# Hennig Hasemann (http://leetless.de/vim.html)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#061229"
gsettings set "$SCHEMA" foreground "#b8bbc2"
gsettings set "$SCHEMA" palette "#061229:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#b8bbc2:#717885:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#ffffff"
gsettings set "$SCHEMA" cursor-color "#2a3448"

unset SCHEMA
