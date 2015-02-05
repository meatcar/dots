#!/usr/bin/env bash
# Base16 Colors - Pantheon Terminal color scheme install script
# mrmrs (http://clrs.cc)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#555555"
gsettings set "$SCHEMA" palette "#ffffff:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#bbbbbb:#777777:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#111111"
gsettings set "$SCHEMA" cursor-color "#111111"

unset SCHEMA
