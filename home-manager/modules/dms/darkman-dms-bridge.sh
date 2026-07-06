#!/usr/bin/env bash
# Mirror the gnome portal's appearance color-scheme (which DMS drives via
# gsettings) into `darkman set`, so darkman's hooks track DMS. One-way: darkman's
# scheduler and gtk-theme/dms hooks are disabled in the dms module, so no loop.
set -euo pipefail

dest=org.freedesktop.portal.Desktop
path=/org/freedesktop/portal/desktop

# freedesktop appearance color-scheme: 1 = dark, 0/2 = light.
apply() {
  case "$1" in
  1) darkman set dark ;;
  *) darkman set light ;;
  esac
}

# The value sits after the "uint32" token, e.g. "(<<uint32 1>>,)" or a
# SettingChanged line; grab the trailing number so we don't match the 32.
scheme_of() {
  printf '%s' "$1" | grep -oE 'uint32 [0-9]+' | grep -oE '[0-9]+' | tail -n1
}

# Prime darkman from the current value before following changes.
current=$(gdbus call --session --dest "$dest" --object-path "$path" \
  --method org.freedesktop.portal.Settings.Read \
  org.freedesktop.appearance color-scheme 2>/dev/null) || current=""
if [ -n "$current" ]; then
  val=$(scheme_of "$current") || val=""
  [ -n "$val" ] && { apply "$val" || true; }
fi

gdbus monitor --session --dest "$dest" --object-path "$path" |
  while IFS= read -r line; do
    case "$line" in
    *SettingChanged*org.freedesktop.appearance*color-scheme*)
      val=$(scheme_of "$line") || val=""
      [ -n "$val" ] && { apply "$val" || true; }
      ;;
    esac
  done
