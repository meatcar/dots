#!/bin/sh

nox-update --quiet /run/booted-system /run/current-system |
  grep -v '\.drv : $' |
  sed 's/^ *//' |
  sort -u -k 2 --field-separator='-' # keep nix paths, sort by package name
