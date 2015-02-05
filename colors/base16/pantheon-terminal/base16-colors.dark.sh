#!/usr/bin/env bash
# Base16 Colors - Pantheon Terminal color scheme install script
# mrmrs (http://clrs.cc)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#111111"
gsettings set "$SCHEMA" foreground "#bbbbbb"
gsettings set "$SCHEMA" palette "#111111:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#bbbbbb:#777777:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#ffffff"
gsettings set "$SCHEMA" cursor-color "#333333"

unset SCHEMA
