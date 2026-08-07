#!/usr/bin/env bash

runtime=/run/wireguard-wg0
conf=$runtime/wg0.conf

ip -4 rule del priority 10000 from 10.2.0.2/32 table 51820 2>/dev/null || true
ip -6 rule del priority 10000 from 2a07:b944::2:2/128 table 51820 2>/dev/null || true

if [ -f "$conf" ]; then
  wg-quick down "$conf"
fi

rm -rf "$runtime"
