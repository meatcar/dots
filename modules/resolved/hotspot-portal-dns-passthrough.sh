#!/bin/sh
# Hotspot portals answer with their own DNS, but the global `Domains=~.` in
# resolved.conf outranks a link's DefaultRoute and sends every query to the
# public resolvers, so the portal's hijack never lands.
#
# `browser` needs no privileges: it runs one browser against the hotspot's DNS
# and leaves the host resolver alone. Portals unblock by MAC at the gateway, so
# the rest of the system follows once the form is submitted.
#
# `on` and `off` throw the same switch system-wide, for a portal that needs a
# browser this cannot launch, or a host without unprivileged user namespaces.

self=${0##*/}
state=/run/$self
check_url=http://nmcheck.gnome.org/check_network_status.txt
candidates="helium chromium firefox zen-beta librewolf"

# --- inspection -------------------------------------------------------------

discover_link() {
  link=$(ip -o route show default | sed -n 's/.* dev \([^ ]*\).*/\1/p' | head -n1)
  gateway=$(ip -o route show default | sed -n 's/.* via \([^ ]*\).*/\1/p' | head -n1)
  if [ -z "$link" ]; then
    echo "$self: no default route" >&2
    exit 1
  fi
}

domains() {
  resolvectl domain "$link" | sed -n 's/^[^:]*: *//p'
}

# resolvectl decorates servers with #sni names that resolv.conf cannot parse.
servers() {
  resolvectl dns "$link" | sed -n 's/^[^:]*: *//p' | tr ' ' '\n' | sed 's/#.*//' | grep .
}

overridden() {
  case " $(domains) " in
  *" ~. "*) return 0 ;;
  *) return 1 ;;
  esac
}

verdict() {
  nmcli networking connectivity check 2>/dev/null || echo unknown
}

# The gateway needs no DNS, so it still answers when resolution is broken.
portal() {
  for target in "http://$gateway/" "$check_url"; do
    redirect=$(curl -sS -m 5 -o /dev/null -w '%{redirect_url}' "$target" 2>/dev/null || true)
    if [ -n "$redirect" ]; then
      printf '%s\n' "$redirect"
      return 0
    fi
  done
  return 0
}

# A gateway that redirects proves nothing: many keep doing it after login. Only
# NetworkManager's verdict says whether traffic is actually being intercepted.
report() {
  if [ "$1" = full ]; then
    echo "portal:   none"
    return 0
  fi
  url=$(portal)
  echo "portal:   ${url:-none offered}"
}

# --- the switch itself, root only -------------------------------------------

passthrough_on() {
  saved=$(domains)
  if ! overridden; then
    mkdir -p "$state"
    printf '%s\n' "$saved" >"$state/$link"
  fi
  # shellcheck disable=SC2086 # deliberate split: one argument per domain
  resolvectl domain "$link" $saved '~.'
  resolvectl flush-caches
}

# Prints the domains it restored.
passthrough_off() {
  saved=""
  if [ -f "$state/$link" ]; then
    saved=$(cat "$state/$link")
  fi
  if [ -n "$saved" ]; then
    # shellcheck disable=SC2086 # deliberate split: one argument per domain
    resolvectl domain "$link" $saved
  else
    resolvectl domain "$link" ""
  fi
  rm -f "$state/$link"
  resolvectl flush-caches
  echo "${saved:-none}"
}

# --- sandboxed browser ------------------------------------------------------

# Unanchored: real binaries are google-chrome-stable, ungoogled-chromium, and
# the like, so matching a leading vendor word misses most of them.
browser_family() {
  case ${1##*/} in
  *firefox* | *waterfox* | *librewolf* | *floorp* | *icecat* | \
    *tor-browser* | *mullvad-browser* | zen | zen-*) echo firefox ;;
  *chromium* | *chrome* | *helium* | *brave* | *vivaldi* | \
    *edge* | *opera* | *thorium*) echo chromium ;;
  *) echo unknown ;;
  esac
}

default_browser() {
  for candidate in $candidates; do
    if command -v "$candidate" >/dev/null 2>&1; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
}

# browser_argv <url> <command...>, one argv element per line. The flags pin a
# known browser to a new process, so it cannot hand the URL to a running
# instance outside the sandbox. An unrecognised command is run as given, with a
# warning: the handoff it may do is silent and looks like success.
browser_argv() {
  target=$1
  shift
  printf '%s\n' "$@"
  case $(browser_family "$1") in
  firefox)
    mkdir -p "$jail/profile"
    # DoH would tunnel past the passthrough to a public resolver.
    printf 'user_pref("network.trr.mode", 5);\n' >"$jail/profile/user.js"
    printf -- '--profile\n%s\n--no-remote\n--new-instance\n' "$jail/profile"
    ;;
  chromium)
    printf -- '--user-data-dir=%s\n--disable-features=DnsOverHttps\n--no-first-run\n' \
      "$jail/profile"
    ;;
  *)
    echo "$self: $1 unrecognised, no isolation flags: it may pass the URL to a running browser outside the sandbox" >&2
    ;;
  esac
  printf '%s\n' "$target"
}

# nss-resolve would hand the query straight back to resolved, and nscd would
# answer it from outside the sandbox. Both have to go.
run_sandboxed() {
  # shellcheck disable=SC2046 # deliberate split: one nameserver line each
  printf 'nameserver %s\n' $(servers) >"$jail/resolv.conf"
  printf 'hosts: files dns\n' >"$jail/nsswitch.conf"
  bwrap --dev-bind / / \
    --tmpfs /run/nscd \
    --bind "$jail/resolv.conf" "$(readlink -f /etc/resolv.conf)" \
    --bind "$jail/nsswitch.conf" "$(readlink -f /etc/nsswitch.conf)" \
    "$@"
}

# --- commands ---------------------------------------------------------------

cmd_status() {
  access=$(verdict)
  echo "link:     $link"
  echo "gateway:  $gateway"
  echo "access:   $access"
  echo "servers:  $(servers | tr '\n' ' ')"
  echo "domains:  $(domains)"
  if overridden; then
    echo "override: on"
  else
    echo "override: off"
  fi
  report "$access"
  if overridden && [ "$access" = full ]; then
    echo "next:     $self off"
  elif [ "$access" != full ]; then
    echo "next:     $self browser"
  fi
}

cmd_browser() {
  if [ "$(id -u)" -eq 0 ]; then
    echo "$self: run as a normal user" >&2
    exit 1
  fi
  if [ $# -eq 0 ]; then
    # shellcheck disable=SC2046 # a bare command name, no splitting to fear
    set -- $(default_browser)
  fi
  if [ $# -eq 0 ]; then
    echo "$self: no browser in \"$candidates\", pass one as an argument" >&2
    exit 1
  fi
  if [ -z "$(servers)" ]; then
    echo "$self: $link advertises no DNS server" >&2
    exit 1
  fi

  jail=$(mktemp -d -t "$self.XXXXXX")
  trap 'rm -rf "$jail"' EXIT INT TERM

  url=$(portal)
  : "${url:=http://$gateway/}"
  echo "$self: $1 $url via $(servers | head -n1)"

  # Split on newlines only, so a space in the URL or the jail path stays put.
  oldifs=$IFS
  IFS='
'
  # shellcheck disable=SC2046 # deliberate split: one argument per line
  set -- $(browser_argv "$url" "$@")
  IFS=$oldifs
  run_sandboxed "$@"
}

cmd_on() {
  passthrough_on
  echo "$self: $link DNS preferred, undo with \`$self off\`"
}

cmd_off() {
  echo "$self: $link domains restored to $(passthrough_off)"
}

# --- argument parsing -------------------------------------------------------

usage() {
  cat >&2 <<EOF
Usage: $self [status|on|off]
       $self browser [command ...]

  status   (default) link, resolver routing, and portal
  browser  open the portal in a sandboxed browser using the hotspot's DNS,
           defaulting to the first of: $candidates
  on       point the whole system at the hotspot's DNS (root)
  off      undo \`on\`
EOF
  exit 64
}

needs_root() {
  case $1 in
  on | off) return 0 ;;
  *) return 1 ;;
  esac
}

main() {
  action=${1:-status}
  case $action in
  status | on | off) [ $# -le 1 ] || usage ;;
  browser) ;;
  *) usage ;;
  esac
  [ $# -eq 0 ] || shift

  discover_link

  if needs_root "$action" && [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$action"
  fi

  case $action in
  status) cmd_status ;;
  browser) cmd_browser "$@" ;;
  on) cmd_on ;;
  off) cmd_off ;;
  esac
}

main "$@"
