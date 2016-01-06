#!/usr/bin/env bash
# Base16 Darktooth - Pantheon Terminal color scheme install script
# Jason Milkins (https://github.com/jasonm23)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#FDF4C1"
gsettings set "$SCHEMA" foreground "#504945"
gsettings set "$SCHEMA" palette "#FDF4C1:#FB543F:#95C085:#FAC03B:#0D6678:#8F4673:#8BA59B:#A89984:#665C54:#FB543F:#95C085:#FAC03B:#0D6678:#8F4673:#8BA59B:#1D2021"
gsettings set "$SCHEMA" cursor-color "#1D2021"

unset SCHEMA
