#!/bin/sh
case "$1" in
root | nixos) exec curl --fail --silent --show-error --max-time 10 https://github.com/meatcar.keys ;;
*) exit 0 ;;
esac
