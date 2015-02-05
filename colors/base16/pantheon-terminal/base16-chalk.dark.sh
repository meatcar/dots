#!/usr/bin/env bash
# Base16 Chalk - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#151515"
gsettings set "$SCHEMA" foreground "#d0d0d0"
gsettings set "$SCHEMA" palette "#151515:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#d0d0d0:#505050:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#f5f5f5"
gsettings set "$SCHEMA" cursor-color "#202020"

unset SCHEMA
