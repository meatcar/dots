#!/usr/bin/env bash

source=${1:?}
runtime=/run/wireguard-wg0
conf=$runtime/wg0.conf

install -d -m 0700 "$runtime"
umask 077
awk '
  /^\[Interface\][[:space:]]*$/ {
    interface = 1
    print
    next
  }
  /^\[/ {
    if (interface) print "Table = off"
    interface = 0
  }
  interface && /^[[:space:]]*(DNS|Table|PreUp|PostUp|PreDown|PostDown)[[:space:]]*=/ { next }
  { print }
  END {
    if (interface) print "Table = off"
  }
' "$source" >"$conf"

cleanup() {
  ip -4 rule del priority 10000 from 10.2.0.2/32 table 51820 2>/dev/null || true
  ip -6 rule del priority 10000 from 2a07:b944::2:2/128 table 51820 2>/dev/null || true
  wg-quick down "$conf" 2>/dev/null || true
}
trap cleanup ERR

modprobe wireguard
wg-quick up "$conf"
ip -4 route replace 10.2.0.1/32 dev wg0
ip -4 route replace default dev wg0 table 51820
ip -6 route replace default dev wg0 table 51820
ip -4 rule add priority 10000 from 10.2.0.2/32 table 51820
ip -6 rule add priority 10000 from 2a07:b944::2:2/128 table 51820

trap - ERR
