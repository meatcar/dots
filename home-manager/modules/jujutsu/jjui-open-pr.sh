#!/bin/sh
# Open the GitHub PR for a branch in the default browser.

if [ $# -ne 1 ]; then
  echo "usage: ${0##*/} <branch>" >&2
  exit 2
fi

url=$(gh pr view "$1" --json url --jq .url)
# NOTE: detach and drop stdio. jjui waits until all writers of its pipes close.
setsid -f xdg-open "$url" >/dev/null 2>&1 </dev/null
