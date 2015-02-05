#!/usr/bin/env bash
# Base16 Monokai - Pantheon Terminal color scheme install script
# Wimer Hazenberg (http://www.monokai.nl)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#272822"
gsettings set "$SCHEMA" foreground "#f8f8f2"
gsettings set "$SCHEMA" palette "#272822:#f92672:#a6e22e:#f4bf75:#66d9ef:#ae81ff:#a1efe4:#f8f8f2:#75715e:#f92672:#a6e22e:#f4bf75:#66d9ef:#ae81ff:#a1efe4:#f9f8f5"
gsettings set "$SCHEMA" cursor-color "#383830"

unset SCHEMA
