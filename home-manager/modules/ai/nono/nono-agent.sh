#!/usr/bin/env bash
# Run a coding agent headlessly under nono, with egress narrowed to net-tight.
# Interactive sessions use the sclaude/scodex/spi abbreviations instead: they
# keep the pack profile's open egress, which agents need for browsing docs.
#
#   nono-agent [nono run flags...] -- <agent cmd> [args...]
#   nono-agent <agent cmd> [args...]
#
# Flags land on `nono run`, so extra bases compose and the base profile is
# still overridable:
#   nono-agent --extends python-dev -- claude -p hi
#   nono-agent --profile nolabs-ai/codex -- codex exec hi
set -eu -o pipefail

usage() {
  echo "usage: nono-agent [nono run flags...] -- <agent cmd> [args...]" >&2
  exit 64
}

# Flags need a `--` terminator: value-taking flags (--extends foo) make a bare
# word ambiguous, so we can't guess where the agent command starts without it.
argv=("$@")
flags=()
while [ "$#" -gt 0 ] && [ "$1" != "--" ]; do
  flags+=("$1")
  shift
done
if [ "$#" -eq 0 ]; then
  set -- "${argv[@]+"${argv[@]}"}"
  flags=()
else
  shift
fi

[ "$#" -ge 1 ] || usage

# Agents nono packages get their own pack profile; anything else falls back to
# a generic base. An explicit --profile still wins over the env var.
case "$1" in
claude | codex | pi) profile="nolabs-ai/$1" ;;
*) profile="subagent" ;;
esac

export NONO_PROFILE="${NONO_PROFILE:-$profile}"
# else the alt-screen watchdog kills it for never drawing a TUI
export NONO_STARTUP_TIMEOUT="${NONO_STARTUP_TIMEOUT:-0}"

# --allow-cwd has no env equivalent, and a headless run gets no worktree at all
# without it.
exec nono run --extends net-tight --allow-cwd "${flags[@]+"${flags[@]}"}" -- "$@"
