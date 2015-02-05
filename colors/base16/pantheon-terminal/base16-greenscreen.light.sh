#!/usr/bin/env bash
# Base16 Green Screen - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#00ff00"
gsettings set "$SCHEMA" foreground "#005500"
gsettings set "$SCHEMA" palette "#00ff00:#007700:#00bb00:#007700:#009900:#00bb00:#005500:#00bb00:#007700:#007700:#00bb00:#007700:#009900:#00bb00:#005500:#001100"
gsettings set "$SCHEMA" cursor-color "#001100"

unset SCHEMA
