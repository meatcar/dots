#!/usr/bin/env bash
# Base16 Pop - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#303030"
gsettings set "$SCHEMA" palette "#ffffff:#eb008a:#37b349:#f8ca12:#0e5a94:#b31e8d:#00aabb:#d0d0d0:#505050:#eb008a:#37b349:#f8ca12:#0e5a94:#b31e8d:#00aabb:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
