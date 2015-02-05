#!/usr/bin/env bash
# Base16 Paraiso - Pantheon Terminal color scheme install script
# Jan T. Sott
# Charles B Johnson (https://github.com/charlesbjohnson)

SCHEMA="org.pantheon.terminal.settings"

gsettings set "$SCHEMA" background "#2f1e2e"
gsettings set "$SCHEMA" foreground "#a39e9b"
gsettings set "$SCHEMA" palette "#2f1e2e:#ef6155:#48b685:#fec418:#06b6ef:#815ba4:#5bc4bf:#a39e9b:#776e71:#ef6155:#48b685:#fec418:#06b6ef:#815ba4:#5bc4bf:#e7e9db"
gsettings set "$SCHEMA" cursor-color "#41323f"

unset SCHEMA
