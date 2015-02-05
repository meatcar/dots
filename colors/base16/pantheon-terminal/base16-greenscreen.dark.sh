#!/usr/bin/env bash
# Base16 Green Screen - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#001100"
gsettings set "$SCHEMA" foreground "#00bb00"
gsettings set "$SCHEMA" palette "#001100:#007700:#00bb00:#007700:#009900:#00bb00:#005500:#00bb00:#007700:#007700:#00bb00:#007700:#009900:#00bb00:#005500:#00ff00"
gsettings set "$SCHEMA" cursor-color "#003300"

unset SCHEMA
