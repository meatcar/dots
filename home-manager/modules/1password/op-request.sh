#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: op-request --why REASON [--for DURATION] op://REFERENCE...
       op-request --why REASON [--for DURATION] -- OP_ARGS...

Run one 1Password CLI request behind a prompt that says who asks, from which
project, for what, why, and for how long:

  Allow 🤖 Amp 📁 accounting 🔑 Private/Scotia iTrade/password
  💬 sign in to scotiabank.com ⏱ 2m to get CLI access

  --why  what the secret is for, up to 80 characters
  --for  time limit including the wait for approval: Ns, Nm, or Nh (default 1m)

Example:
  password=$(op-request --why "sign in to scotiabank.com" --for 2m \
    "op://Private/Scotia iTrade/password")

References print one value per line, in order; one approval covers them all.
Use names, not item IDs, so the prompt is readable. Stdout carries secrets:
capture it, never print or log it.

Who asks is 🤖 Amp inside an Amp thread, else ⚙ the calling program. The project
is the git repository of the working directory, else the directory name.
Only OP_ACCOUNT passes through to op.

Exit status: 2 for bad usage, else op's status. A denied prompt or a request
that passes DURATION exits non-zero with the reason on stderr.
EOF
}

die() {
  printf 'op-request: %s\n' "$1" >&2
  exit 2
}

has_control() {
  case $1 in *[[:cntrl:]]*) return 0 ;; esac
  return 1
}

why=
limit=1m
while [ $# -gt 0 ]; do
  case $1 in
  --why | --for)
    [ $# -ge 2 ] || die "$1 needs a value"
    if [ "$1" = --why ]; then why=$2; else limit=$2; fi
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  --)
    shift
    break
    ;;
  -*) die "unknown option $1; see --help" ;;
  *) break ;;
  esac
done

[ -n "$why" ] || die "--why is required; see --help"
[ "${#why}" -le 80 ] || die "--why has ${#why} characters; shorten it to 80"
! has_control "$why" || die "--why cannot contain control characters"
printf '%s\n' "$limit" | grep -Eqx '[1-9][0-9]*[smh]' || die "--for must look like 30s, 5m, or 1h, not '$limit'"
[ $# -gt 0 ] || die "missing op://references or -- OP_ARGS; see --help"

mode=refs
for arg; do
  case $arg in op://*) ;; *) mode=args ;; esac
  ! has_control "$arg" || die "arguments cannot contain control characters"
done
if [ "$mode" = refs ]; then
  what=$(printf '%s, ' "$@" | sed 's|op://||g; s|, $||')
else
  what="op $*"
fi

if [ -n "${AMP_CURRENT_THREAD_ID:-}" ]; then
  who="🤖 Amp"
else
  who="⚙ $(cat "/proc/$PPID/comm")"
fi
common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) &&
  project=$(basename "$(dirname "$common")") ||
  project=$(basename "$PWD")

! has_control "$who$project" || die "the working directory or caller name contains control characters"
# NOTE: 1Password shows the file name as one wrapping line; it collapses every line break.
# Icons mark the fields, U+00A0 keeps short fields whole, U+2215 stands in for '/'.
nbsp=$(printf '\302\240')
whole() { printf '%s' "$*" | sed "s/ /$nbsp/g"; }
label="$(whole "$who") 📁$nbsp$(whole "$project") 🔑$nbsp$what 💬$nbsp$why ⏱$nbsp$limit"
label=$(printf '%s' "$label" | sed 's|/|∕\xe2\x80\x8b|g')
[ "$(printf '%s' "$label" | wc -c)" -le 255 ] ||
  die "the prompt text exceeds 255 bytes; shorten --why or request fewer references"

runtime="${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set; run op-request inside a user session}/op-request"
[ -d "$runtime" ] || mkdir -m 700 "$runtime"
[ -e "$runtime/CACHEDIR.TAG" ] ||
  printf 'Signature: 8a477f597d28d172789f06886806bc55\n' >"$runtime/CACHEDIR.TAG"
request=$(mktemp -d "$runtime/XXXXXX")
trap 'rm -rf "$request"' EXIT
caller="$request/$label"
cp "$(command -v script)" "$caller"

seconds=${limit%?}
case $limit in
*m) seconds=$((seconds * 60)) ;;
*h) seconds=$((seconds * 3600)) ;;
esac

# NOTE: 1Password names the top process of a terminal session in its prompt and scopes the
# approval to that terminal. A renamed `script` in its own user unit is that process, with a
# terminal that exists only for this request. op output bypasses the terminal via fd 3 and 4.
quote() { printf "'%s' " "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }
op=$(quote /run/wrappers/bin/op)
{
  echo 'exec 1>&3 2>&4 3>&- 4>&-'
  if [ "$mode" = args ]; then
    printf 'exec %s' "$op"
    for arg; do quote "$arg"; done
    echo
  else
    for reference; do printf '%sread %s|| exit\n' "$op" "$(quote "$reference")"; done
  fi
} >"$request/run"

dash=$(command -v dash)
start=$(date +%s)
status=0
# NOTE: script runs its command through $SHELL; the caller's SHELL may be fish.
# shellcheck disable=SC2016
systemd-run --user --pipe --wait --quiet --collect --same-dir \
  --unit="op-request-$$" \
  --description="op-request: $label (cwd $PWD${AMP_CURRENT_THREAD_ID:+, thread $AMP_CURRENT_THREAD_ID})" \
  --property=RuntimeMaxSec="$limit" --setenv=SHELL="$dash" ${OP_ACCOUNT:+--setenv=OP_ACCOUNT} \
  -- "$dash" -c 'exec "$0" -qec "$1" /dev/null 3>&1 4>&2 >&2' \
  "$caller" "$dash $request/run" </dev/null || status=$?
if [ "$status" -ne 0 ] && [ $(($(date +%s) - start)) -ge "$seconds" ]; then
  printf 'op-request: stopped after %s; approve sooner or raise --for\n' "$limit" >&2
fi
exit "$status"
