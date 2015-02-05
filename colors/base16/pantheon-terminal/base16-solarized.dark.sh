#!/usr/bin/env bash
# Base16 Solarized - Pantheon Terminal color scheme install script
# Ethan Schoonover (http://ethanschoonover.com/solarized)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#002b36"
gsettings set "$SCHEMA" foreground "#93a1a1"
gsettings set "$SCHEMA" palette "#002b36:#dc322f:#859900:#b58900:#268bd2:#6c71c4:#2aa198:#93a1a1:#657b83:#dc322f:#859900:#b58900:#268bd2:#6c71c4:#2aa198:#fdf6e3"
gsettings set "$SCHEMA" cursor-color "#073642"

unset SCHEMA
