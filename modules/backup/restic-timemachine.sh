#!/usr/bin/env bash
set -euo pipefail

[ "$(id -u)" -eq 0 ] || exec sudo "$0" "$@"

config="${BACKREST_CONFIG:-/var/lib/backrest/config.json}"
thorough=false
refresh=false

usage() {
  echo "Usage: restic-timemachine [--thorough] [--refresh] <repo-id> <file-path>" >&2
  echo "  --thorough  check all snapshot pairs, even when size is unchanged (slower)" >&2
  echo "  --refresh   ignore cache and re-query" >&2
  echo "" >&2
  echo "Available repos:" >&2
  jq -r '.repos[].id' "$config" >&2
  exit 1
}

while [[ ${1:-} == --* ]]; do
  case "$1" in
  --thorough)
    thorough=true
    shift
    ;;
  --refresh)
    refresh=true
    shift
    ;;
  *) usage ;;
  esac
done

[ $# -ge 2 ] || usage

repo_id="$1"
file_path="$2"

cache_dir="${XDG_CACHE_HOME:-/root/.cache}/restic-timemachine"
mkdir -p "$cache_dir"
cache_key="${repo_id}__${file_path//[^a-zA-Z0-9._-]/_}"

# Window schedule in days; 0 = all time (no --oldest limit)
windows=(7 30 90 0)
window_idx=0
entries=()
i=0

load_window() {
  local days="${windows[$window_idx]}"
  local label
  [ "$days" -gt 0 ] && label="${days} days" || label="all time"
  local window_cache="${cache_dir}/${cache_key}__${days}d"

  if [ "$refresh" = true ] || [ ! -f "$window_cache" ]; then
    echo "Fetching snapshots ($label)..." >&2
    if [ "$days" -gt 0 ]; then
      local oldest
      oldest=$(date -d "$days days ago" '+%Y-%m-%dT%H:%M:%S')
      restic-backrest "$repo_id" find --json -l --oldest "$oldest" "$file_path"
    else
      restic-backrest "$repo_id" find --json -l "$file_path"
    fi | jq -r '.[] | [.snapshot, (.matches[0].size | tostring), .matches[0].mtime] | @tsv' \
      >"$window_cache"
  else
    echo "Using cached results ($label). --refresh to re-query." >&2
  fi

  mapfile -t entries <"$window_cache"
  echo "Found ${#entries[@]} snapshots." >&2
}

show_diff() {
  {
    diff -u \
      <(restic-backrest "$repo_id" dump "$a_snap" "$file_path" 2>/dev/null || true) \
      <(restic-backrest "$repo_id" dump "$b_snap" "$file_path" 2>/dev/null || true) ||
      true
  } | delta
}

restore_snapshot() {
  local snap="$1"
  local backup
  backup="${file_path}.$(date +%Y%m%dT%H%M%S)"
  echo "Backing up current file to $backup"
  cp "$file_path" "$backup"
  echo "Restoring from snapshot $snap..."
  restic-backrest "$repo_id" restore "$snap" --target / --include "$file_path"
  echo "Restored."
  exit 0
}

load_window
[ "${#entries[@]}" -gt 1 ] || {
  echo "Nothing to compare." >&2
  exit 0
}

while true; do
  total=${#entries[@]}

  while ((i < total - 1)); do
    IFS=$'\t' read -r b_snap b_size b_time <<<"${entries[$i]}"
    IFS=$'\t' read -r a_snap a_size _ <<<"${entries[$((i + 1))]}"
    i=$((i + 1))

    if [ "$thorough" = false ] && [ "$b_size" = "$a_size" ]; then
      continue
    fi

    echo "=== $b_snap  $b_time  ($a_size → $b_size bytes) ==="
    show_diff

    while true; do
      printf '\n[o] older (%s B, before)  [n] newer (%s B, after)  [d] redisplay  [Enter] next  [q] quit: ' \
        "$a_size" "$b_size" >/dev/tty
      read -r answer </dev/tty
      case "$answer" in
      [oO]*) restore_snapshot "$a_snap" ;;
      [nN]*) restore_snapshot "$b_snap" ;;
      [dD]*) show_diff ;;
      [qQ]*) exit 0 ;;
      *) break ;;
      esac
    done
  done

  # Exhausted current window — try expanding
  window_idx=$((window_idx + 1))
  if ((window_idx >= ${#windows[@]})); then
    echo "No more snapshots to search." >&2
    break
  fi

  next_days=${windows[$window_idx]}
  [ "$next_days" -gt 0 ] && next_label="${next_days} days" || next_label="all time"
  printf "Extend search to %s? [Y/n] " "$next_label" >/dev/tty
  read -r answer </dev/tty
  [[ $answer == [nNqQ]* ]] && exit 0

  old_total=$total
  load_window

  if ((${#entries[@]} <= old_total)); then
    echo "No additional snapshots found." >&2
    break
  fi

  echo "Found $((${#entries[@]} - old_total)) more snapshots." >&2
  # i is positioned at old_total-1: the boundary between old and new entries
done
