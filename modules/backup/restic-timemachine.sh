#!/usr/bin/env bash
set -euo pipefail

[ "$(id -u)" -eq 0 ] || exec sudo "$0" "$@"

read -ra backup_names <<<'@backupNames@'
parallel_jobs=8

usage() {
  cat >&2 <<EOF
Usage: restic-timemachine [--backup NAME] <file-path>

Pick a backed-up version of a file and restore it.
  file-path      relative or absolute; /home/... maps to /persist/home/...
  --backup NAME  backup to search (default: the only one configured)
Backups: ${backup_names[*]}

In the picker:
  Enter   restore the version (current file is saved in @savedDir@)
  Ctrl-O  print the version to stdout
  Esc     quit
EOF
  exit "${1:-1}"
}

backup=""
while [[ ${1:-} == -* ]]; do
  case "$1" in
  -b | --backup)
    [ $# -ge 2 ] || usage
    backup="$2"
    shift 2
    ;;
  -h | --help) usage 0 ;;
  *) usage ;;
  esac
done
[ $# -eq 1 ] || usage

if [ -z "$backup" ]; then
  if [ "${#backup_names[@]}" -ne 1 ]; then
    echo "error: several backups configured; pick one with --backup: ${backup_names[*]}" >&2
    exit 1
  fi
  backup="${backup_names[0]}"
fi

# NOTE: -m accepts deleted files. Snapshots store paths under /persist.
file_path=$(realpath -m -- "$1")
if [[ $file_path != /persist/* ]]; then
  if [ -e "$file_path" ] && [ ! -e "/persist${file_path}" ]; then
    echo "error: $file_path is not persisted under /persist, so it is not backed up" >&2
    exit 1
  fi
  file_path="/persist${file_path}"
fi

current="$file_path"
[ -f "$current" ] || current=/dev/null

cache_dir="@cacheDir@/${backup}/$(printf '%s' "$file_path" | sha256sum | cut -c1-16)"
snapshots_dir="${cache_dir}/snapshots"
versions_dir="${cache_dir}/versions"
saved_dir=@savedDir@
mkdir -p "$snapshots_dir" "$versions_dir"

# Snapshot contents never change, so each snapshot is queried once per file.
# NOTE: exported for fzf and xargs subshells, which do not inherit set options.
fetch_snapshot() {
  local - out="${snapshots_dir}/$1"
  set -euo pipefail
  restic-job "$backup" ls --no-lock --json "$1" "$file_path" |
    jq -r --arg path "$file_path" \
      'select(.message_type == "node" and .path == $path and .type == "file") | [.mtime, (.size | tostring)] | @tsv' \
      >"${out}.partial"
  mv "${out}.partial" "$out"
}

ensure_version() {
  local - out="${versions_dir}/$1"
  set -euo pipefail
  if [ ! -e "$out" ]; then
    restic-job "$backup" dump --no-lock "$2" "$file_path" >"${out}.partial"
    mv "${out}.partial" "$out"
  fi
  printf '%s\n' "$out"
}

preview_version() {
  local - version
  set -euo pipefail
  version=$(ensure_version "$1" "$2")
  if cmp -s "$current" "$version"; then
    echo "Same as the current file."
  else
    diff -u --label current --label "$3" "$current" "$version" |
      delta --paging=never --width="${FZF_PREVIEW_COLUMNS:-80}"
  fi
}

export backup file_path current snapshots_dir versions_dir
export -f fetch_snapshot ensure_version preview_version

mapfile -t snapshots < <(
  restic-job "$backup" snapshots --no-lock --json |
    jq -r 'sort_by(.time) | reverse | .[] | [.id, .time] | @tsv'
)

missing=()
for snapshot in "${snapshots[@]}"; do
  id="${snapshot%%$'\t'*}"
  [ -e "${snapshots_dir}/${id}" ] || missing+=("$id")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Scanning ${#missing[@]} of ${#snapshots[@]} snapshots for $file_path..." >&2
  printf '%s\n' "${missing[@]}" |
    xargs -P "$parallel_jobs" -I {} bash -c 'fetch_snapshot {}'
fi

# A version is a distinct (mtime, size); edits change mtime, so equal pairs hold equal content.
declare -A version_count=()
version_ids=()
declare -A version_snapshot=() version_mtime=() version_size=()
for snapshot in "${snapshots[@]}"; do
  id="${snapshot%%$'\t'*}"
  [ -s "${snapshots_dir}/${id}" ] || continue
  IFS=$'\t' read -r mtime size <"${snapshots_dir}/${id}"
  version="$(date -d "$mtime" +%s)_${size}"
  if [ -z "${version_count[$version]:-}" ]; then
    version_ids+=("$version")
    version_snapshot[$version]="$id"
    version_mtime[$version]="$mtime"
    version_size[$version]="$size"
    version_count[$version]=0
  fi
  version_count[$version]=$((version_count[$version] + 1))
done

if [ "${#version_ids[@]}" -eq 0 ]; then
  echo "error: no snapshot of '$backup' contains $file_path" >&2
  exit 1
fi

current_version=""
[ "$current" = /dev/null ] || current_version="$(stat -c '%Y_%s' "$current")"

rows=()
for version in "${version_ids[@]}"; do
  marker=" "
  [ "$version" != "$current_version" ] || marker="*"
  label="${marker} $(date -d "${version_mtime[$version]}" '+%Y-%m-%d %H:%M')$(numfmt --to=iec --suffix=B --padding=7 "${version_size[$version]}")  ×${version_count[$version]}"
  rows+=("${version}"$'\t'"${version_snapshot[$version]}"$'\t'"${label}")
done

SHELL=$(command -v bash)
export SHELL
selection=$(
  printf '%s\n' "${rows[@]}" |
    fzf --layout=reverse --delimiter=$'\t' --with-nth=3 --no-sort --expect=ctrl-o \
      --header="$file_path"$'\n* current  ×N snapshots\nEnter: restore  Ctrl-O: print  Esc: quit' \
      --preview='preview_version {1} {2} {3}' --preview-window=right,65%
) || exit 0

key="$(sed -n 1p <<<"$selection")"
IFS=$'\t' read -r version snapshot _ <<<"$(sed -n 2p <<<"$selection")"
contents=$(ensure_version "$version" "$snapshot")

if [ "$key" = ctrl-o ]; then
  cat "$contents"
  exit 0
fi

if [ "$current" != /dev/null ]; then
  if cmp -s "$current" "$contents"; then
    echo "The current file already matches this version." >&2
    exit 0
  fi
  name="${file_path##*/}"
  if [[ $name == ?*.* ]]; then
    stem="${name%.*}" extension=".${name##*.}"
  else
    stem="$name" extension=""
  fi
  mkdir -p "$saved_dir"
  saved="${saved_dir}/${stem}.$(date +%Y%m%dT%H%M%S)${extension}"
  cp -p "$current" "$saved"
  echo "Saved the current file to $saved" >&2
fi

restic-job "$backup" restore "$snapshot" --target / --include "$file_path"
echo "Restored $file_path from snapshot ${snapshot:0:8}." >&2
