#!/usr/bin/env bash
# Base16 Summerfruit - Pantheon Terminal color scheme install script
# Christopher Corley (http://cscorley.github.io/)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#151515"
gsettings set "$SCHEMA" foreground "#D0D0D0"
gsettings set "$SCHEMA" palette "#151515:#FF0086:#00C918:#ABA800:#3777E6:#AD00A1:#1faaaa:#D0D0D0:#505050:#FF0086:#00C918:#ABA800:#3777E6:#AD00A1:#1faaaa:#FFFFFF"
gsettings set "$SCHEMA" cursor-color "#202020"

unset SCHEMA
