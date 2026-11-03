#!/bin/sh
# Put Tailscale routes ahead of NetBird's routing rules (priorities 105/110),
# so a NetBird exit node cannot capture the tailnet. Each VPN's own encrypted
# traffic keeps using the physical network.
#
# Usage: vpn-route-precedence add|del
set -eu

action=${1:?usage: vpn-route-precedence add|del}

apply() {
  family=$1
  shift
  # NOTE: Delete first; `ip rule add` duplicates an existing rule.
  while ip "$family" rule del "$@" 2>/dev/null; do :; done
  if [ "$action" = add ]; then
    ip "$family" rule add "$@"
  fi
}

for family in -4 -6; do
  # Tailscale WireGuard traffic
  apply "$family" priority 95 fwmark 0x80000/0xff0000 lookup main
  # NetBird WireGuard, signal, and management traffic
  apply "$family" priority 95 fwmark 0x1bd00 lookup main
  # Tailscale routes except the exit node default, which stays at 5270
  apply "$family" priority 100 lookup 52 suppress_prefixlength 0
done
