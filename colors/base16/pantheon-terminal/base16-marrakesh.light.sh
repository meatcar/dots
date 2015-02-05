#!/usr/bin/env bash
# Base16 Marrakesh - Pantheon Terminal color scheme install script
# Alexandre Gavioli (http://github.com/Alexx2/)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#faf0a5"
gsettings set "$SCHEMA" foreground "#5f5b17"
gsettings set "$SCHEMA" palette "#faf0a5:#c35359:#18974e:#a88339:#477ca1:#8868b3:#75a738:#948e48:#6c6823:#c35359:#18974e:#a88339:#477ca1:#8868b3:#75a738:#201602"
gsettings set "$SCHEMA" cursor-color "#201602"

unset SCHEMA
