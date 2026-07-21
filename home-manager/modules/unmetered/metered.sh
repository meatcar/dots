#!/usr/bin/env bash
set -euo pipefail

# nm metered state: 0 unknown, 1 yes, 2 no, 3 guess-yes, 4 guess-no
metered() {
  busctl get-property org.freedesktop.NetworkManager \
    /org/freedesktop/NetworkManager \
    org.freedesktop.NetworkManager Metered 2>/dev/null |
    awk '{ print $2 }' || true
}
