#!/usr/bin/env bash
# Base16 PhD - Pantheon Terminal color scheme install script
# Hennig Hasemann (http://leetless.de/vim.html)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#4d5666"
gsettings set "$SCHEMA" palette "#ffffff:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#b8bbc2:#717885:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#061229"
gsettings set "$SCHEMA" cursor-color "#061229"

unset SCHEMA
