#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 || ($# -eq 1 && $1 != --apply) ]]; then
	echo 'Usage: restic-purge-excluded [--apply]' >&2
	exit 2
fi
if ((EUID != 0)); then
	echo 'Run as root: sudo restic-purge-excluded [--apply]' >&2
	exit 1
fi

unit=restic-backups-persist.service
exec_start=$(systemctl show --value -p ExecStart "$unit")
if [[ $exec_start != *' --exclude-caches '* || $exec_start != *' --exclude-file='* ]]; then
	echo "Live $unit does not have --exclude-caches and --exclude-file; refusing to proceed" >&2
	exit 1
fi
exclude_file=${exec_start#*--exclude-file=}
exclude_file=${exclude_file%% *}
if [[ ! -f $exclude_file || ! -r $exclude_file ]]; then
	echo "Cannot read live backup exclusions: $exclude_file" >&2
	exit 1
fi

for service in "$unit" restic-persist-forget.service restic-persist-maintenance.service; do
	state=$(systemctl show --value -p ActiveState "$service")
	if [[ $state != inactive && $state != failed ]]; then
		echo "$service is $state; wait for it to finish before running this script" >&2
		exit 1
	fi
done

patterns=$(mktemp)
tags=$(mktemp)
trap 'rm -f "$patterns" "$tags"' EXIT
cat "$exclude_file" >"$patterns"
if [[ -s $patterns && $(tail -c 1 "$patterns" | od -An -tu1 | tr -d '[:space:]') != 10 ]]; then
	printf '\n' >>"$patterns"
fi
find /persist -type f -name CACHEDIR.TAG -print0 >"$tags"

signature='Signature: 8a477f597d28d172789f06886806bc55'
marked=0
while IFS= read -r -d '' tag; do
	if [[ $(head -c 43 "$tag") != "$signature" ]]; then
		printf 'Skipping invalid tag: %s\n' "$tag" >&2
		continue
	fi
	dir=${tag%/CACHEDIR.TAG}
	if [[ $dir == *'*'* || $dir == *'?'* || $dir == *'['* || $dir == *']'* || $dir == *$'\n'* ]]; then
		printf 'Cannot safely express tagged path as a Restic pattern: %s\n' "$dir" >&2
		exit 1
	fi
	printf '%s\n' "$dir" >>"$patterns"
	((++marked))
done <"$tags"

printf 'Live excludes: %s\nValid cache tags: %d\n' "$exclude_file" "$marked"
echo 'Patterns that will be removed from historical snapshots on --apply:'
cat "$patterns"
echo 'Previewing historical snapshot rewrites (no changes):'
restic-job persist rewrite --dry-run --tag plan:persist,created-by:watson --exclude-file "$patterns"

if [[ ${1:-} != --apply ]]; then
	echo 'No snapshots or repository data changed. Use --apply to rewrite and prune.'
	exit 0
fi

if [[ ! -t 0 ]]; then
	echo 'Apply requires an interactive terminal' >&2
	exit 1
fi
echo 'This permanently removes excluded files from historical snapshots and prunes unreferenced data.'
read -r -p 'Type PURGE to continue: ' answer
if [[ $answer != PURGE ]]; then
	echo 'Cancelled; no changes made.'
	exit 1
fi

restic-job persist rewrite --tag plan:persist,created-by:watson --exclude-file "$patterns" --forget
restic-job persist prune --max-unused 0%
