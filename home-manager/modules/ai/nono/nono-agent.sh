#!/usr/bin/env bash
set -eu -o pipefail

usage() {
  cat >&2 <<'EOF'
usage: nono-agent <context> <claude|codex|pi|amp> [agent arguments...]

Run an agent with its named nono profile. Contexts are declared in
me.ai.nono.contexts; personal and work are installed by default.
EOF
  exit 64
}

[ "$#" -ge 2 ] || usage

context=$1
agent=$2
shift 2

case "$context" in
*[!a-z0-9-]* | '')
  echo "nono-agent: invalid context '$context'" >&2
  usage
  ;;
esac

case "$agent" in
claude | codex | pi | amp) ;;
*)
  echo "nono-agent: unsupported agent '$agent'" >&2
  usage
  ;;
esac

case "$agent" in
codex)
  # nono is the sandbox; codex's own sandbox only blocks project edits.
  exec nono run --profile "$context-$agent" --allow-cwd -- \
    codex --sandbox danger-full-access --ask-for-approval on-request "$@"
  ;;
*)
  exec nono run --profile "$context-$agent" --allow-cwd -- "$agent" "$@"
  ;;
esac
