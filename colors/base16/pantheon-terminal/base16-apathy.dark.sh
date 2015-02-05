#!/usr/bin/env bash
# Base16 Apathy - Pantheon Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#031A16"
gsettings set "$SCHEMA" foreground "#81B5AC"
gsettings set "$SCHEMA" palette "#031A16:#3E9688:#883E96:#3E4C96:#96883E:#4C963E:#963E4C:#81B5AC:#2B685E:#3E9688:#883E96:#3E4C96:#96883E:#4C963E:#963E4C:#D2E7E4"
gsettings set "$SCHEMA" cursor-color "#0B342D"

unset SCHEMA
