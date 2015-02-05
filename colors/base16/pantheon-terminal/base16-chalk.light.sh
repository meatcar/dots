#!/usr/bin/env bash
# Base16 Chalk - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f5f5f5"
gsettings set "$SCHEMA" foreground "#303030"
gsettings set "$SCHEMA" palette "#f5f5f5:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#d0d0d0:#505050:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#151515"
gsettings set "$SCHEMA" cursor-color "#151515"

unset SCHEMA
