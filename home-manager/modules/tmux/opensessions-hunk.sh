#!/usr/bin/env sh
# opensessions runs its diff viewer as `$OPENSESSIONS_LAZYDIFF [--branch]` from
# the session directory: --branch for everything the session did, bare for the
# uncommitted work only.
set -eu

usage() {
  echo "usage: opensessions-hunk [--branch]" >&2
  exit 2
}

git_trunk() {
  git symbolic-ref --quiet --short refs/remotes/origin/HEAD && return 0
  for candidate in main master trunk; do
    if git show-ref --verify --quiet "refs/heads/$candidate"; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

# hunk takes the target as a revset under jj and as a rev under git, so the
# backend decides how the base is named. jj wins colocated repos here, the same
# way hunk's own nearest-checkout detection resolves them.
branch_target() {
  if jj root >/dev/null 2>&1; then
    echo 'trunk()..@'
    return 0
  fi

  trunk=$(git_trunk) || return 1
  git merge-base HEAD "$trunk"
}

case "${1:-}" in
'') exec hunk diff ;;
--branch) ;;
*) usage ;;
esac

if target=$(branch_target); then
  exec hunk diff "$target"
fi

echo "opensessions-hunk: no trunk to diff against, showing the working tree" >&2
exec hunk diff
