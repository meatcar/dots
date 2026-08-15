#!/usr/bin/env bash
# Run a coding agent headlessly under nono, with egress narrowed to net-tight.
# Interactive sessions use the sclaude/scodex/spi abbreviations instead: they
# keep the pack profile's open egress, which agents need for browsing docs.
set -eu -o pipefail

usage() {
  echo "usage: nono-agent <claude|codex|pi> [args...]" >&2
  exit 64
}

[ $# -ge 1 ] || usage

agent=$1
shift

case "$agent" in
claude | codex | pi) ;;
*)
  echo "nono-agent: unknown agent '$agent'" >&2
  usage
  ;;
esac

args=(--profile "nolabs-ai/$agent")
args+=(--extends net-tight)
args+=(--allow-cwd)         # else a headless run gets no worktree at all
args+=(--startup-timeout 0) # else the alt-screen watchdog kills it for never drawing a TUI
args+=(-- "$agent")

exec nono run "${args[@]}" "$@"
