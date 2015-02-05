#!/usr/bin/env bash
# Base16 Default - Pantheon Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f8f8f8"
gsettings set "$SCHEMA" foreground "#383838"
gsettings set "$SCHEMA" palette "#f8f8f8:#ab4642:#a1b56c:#f7ca88:#7cafc2:#ba8baf:#86c1b9:#d8d8d8:#585858:#ab4642:#a1b56c:#f7ca88:#7cafc2:#ba8baf:#86c1b9:#181818"
gsettings set "$SCHEMA" cursor-color "#181818"

unset SCHEMA
