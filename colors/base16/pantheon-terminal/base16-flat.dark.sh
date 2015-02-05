#!/usr/bin/env bash
# Base16 Flat - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#2C3E50"
gsettings set "$SCHEMA" foreground "#e0e0e0"
gsettings set "$SCHEMA" palette "#2C3E50:#E74C3C:#2ECC71:#F1C40F:#3498DB:#9B59B6:#1ABC9C:#e0e0e0:#95A5A6:#E74C3C:#2ECC71:#F1C40F:#3498DB:#9B59B6:#1ABC9C:#ECF0F1"
gsettings set "$SCHEMA" cursor-color "#34495E"

unset SCHEMA
