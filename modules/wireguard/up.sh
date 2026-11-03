#!/usr/bin/env sh
set -eu

ip -4 route replace 10.2.0.1/32 dev wg0
ip -4 route replace default dev wg0 table 51820
ip -4 rule add priority 90 from 10.2.0.2/32 table 51820
