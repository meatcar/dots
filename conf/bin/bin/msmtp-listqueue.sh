#!/usr/bin/env bash

QUEUEDIR=${QUEUEDIR:-$HOME/.msmtpqueue}

for i in "$QUEUEDIR"/*.mail; do
  grep -Es --colour -h '(^From:|^To:|^Subject:)' "$i" || echo "No mail in queue"
  echo " "
done
