#!/usr/bin/env bash
# Turn off Helium's updater in every profile. Helium rewrites Preferences on
# exit, so only edit while it is closed.
# see https://github.com/imputnet/helium/blob/main/patches/helium/core/add-updater-preference.patch
dir="$HOME/Library/Application Support/net.imput.helium"
key=.helium.services.browser_updates

pending=$(
  for prefs in "$dir"/*/Preferences; do
    [ -f "$prefs" ] || continue
    [ "$(jq "$key" "$prefs")" = false ] || printf '%s\n' "$prefs"
  done
)
[ -n "$pending" ] || exit 0

if pgrep -xq Helium; then
  echo "helium-no-update: Helium is running; quit it and re-run activation to disable its updater" >&2
  exit 0
fi

printf '%s\n' "$pending" | while IFS= read -r prefs; do
  updated=$(jq "$key = false" "$prefs") && printf '%s\n' "$updated" >"$prefs"
done
