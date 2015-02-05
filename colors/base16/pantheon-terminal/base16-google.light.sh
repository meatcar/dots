#!/usr/bin/env bash
# Base16 Google - Pantheon Terminal color scheme install script
# Seth Wright (http://sethawright.com)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#ffffff"
gsettings set "$SCHEMA" foreground "#373b41"
gsettings set "$SCHEMA" palette "#ffffff:#CC342B:#198844:#FBA922:#3971ED:#A36AC7:#3971ED:#c5c8c6:#969896:#CC342B:#198844:#FBA922:#3971ED:#A36AC7:#3971ED:#1d1f21"
gsettings set "$SCHEMA" cursor-color "#1d1f21"

unset SCHEMA
