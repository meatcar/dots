#!/usr/bin/env bash
# Base16 Monokai - Pantheon Terminal color scheme install script
# Wimer Hazenberg (http://www.monokai.nl)
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#f9f8f5"
gsettings set "$SCHEMA" foreground "#49483e"
gsettings set "$SCHEMA" palette "#f9f8f5:#f92672:#a6e22e:#f4bf75:#66d9ef:#ae81ff:#a1efe4:#f8f8f2:#75715e:#f92672:#a6e22e:#f4bf75:#66d9ef:#ae81ff:#a1efe4:#272822"
gsettings set "$SCHEMA" cursor-color "#272822"

unset SCHEMA
