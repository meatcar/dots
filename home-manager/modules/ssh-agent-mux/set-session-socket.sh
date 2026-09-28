#!/bin/sh
set -eu

runtime_dir=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
if [ -S "$runtime_dir/bus" ]; then
  XDG_RUNTIME_DIR=$runtime_dir "$1" --user set-environment \
    "SSH_AUTH_SOCK=$runtime_dir/ssh-agent-mux/agent.sock"
fi
