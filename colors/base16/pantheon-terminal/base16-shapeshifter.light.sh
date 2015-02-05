#!/usr/bin/env bash
# Base16 shapeshifter - Pantheon Terminal color scheme install script
# Tyler Benziger (http://tybenz.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f9f9f9"
gsettings set "$SCHEMA" foreground "#102015"
gsettings set "$SCHEMA" palette "#f9f9f9:#e92f2f:#0ed839:#dddd13:#3b48e3:#f996e2:#23edda:#ababab:#343434:#e92f2f:#0ed839:#dddd13:#3b48e3:#f996e2:#23edda:#000000"
gsettings set "$SCHEMA" cursor-color "#000000"

unset SCHEMA
