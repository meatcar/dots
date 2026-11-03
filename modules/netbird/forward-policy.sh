#!/bin/sh
# Load an iptables-restore rule file into a mangle chain and jump to it first
# from FORWARD. The chain is flushed and refilled atomically; never removed,
# so a failed firewall reload keeps the last policy.
#
# Usage: netbird-forward-policy <chain> <IPv4 rules> <IPv6 rules>
set -eu

usage='usage: netbird-forward-policy <chain> <IPv4 rules> <IPv6 rules>'
chain=${1:?$usage}
v4=${2:?$usage}
v6=${3:?$usage}

apply() {
  family=$1
  rules=$2
  "$family-restore" -w --noflush <"$rules"
  if ! "$family" -w -t mangle -C FORWARD -j "$chain" 2>/dev/null; then
    "$family" -w -t mangle -I FORWARD -j "$chain"
  fi
}

apply iptables "$v4"
apply ip6tables "$v6"
echo "netbird-forward-policy: loaded $chain"
