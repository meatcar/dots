#!/usr/bin/env bash
# List upcoming khal events as tab-delimited records for tv/fzf consumption.
# Columns: LINK \t TIME \t CALENDAR \t TITLE \t DESCRIPTION
# LINK is empty for events with no meeting URL.
# Set KHAL_MEETINGS_RANGE to override the lookahead window (default: 14d).

range="${KHAL_MEETINGS_RANGE:-14d}"

{ khal list \
  --day-format '' \
  --format $'\x1eREC\x1f{start-date} {start-time}\x1f{calendar}\x1f{title}\x1f{location}\x1f{description}' \
  now "$range" 2>/dev/null || true; } |
  gawk -v RS=$'\x1e' -v FS=$'\x1f' '
  $1 != "REC" { next }
  {
    time  = $2
    cal   = $3
    title = $4
    loc   = $5
    desc  = $6
    gsub(/[\t\n\r]+/, " ", time)
    gsub(/[\t\n\r]+/, " ", cal)
    gsub(/[\t\n\r]+/, " ", title)
    gsub(/[\t\n\r]+/, " ", loc)
    gsub(/[\t\n\r]+/, " ", desc)
    blob = desc " " loc
    link = ""
    if      (match(blob, /https:\/\/meet\.google\.com\/[a-z0-9?=&._-]+/)) link = substr(blob, RSTART, RLENGTH)
    else if (match(blob, /https:\/\/[a-z0-9.]*zoom\.us\/[^ ]+/))          link = substr(blob, RSTART, RLENGTH)
    else if (match(blob, /https:\/\/teams\.microsoft\.com\/[^ ]+/))       link = substr(blob, RSTART, RLENGTH)
    else if (match(blob, /https?:\/\/[^ ]+/))                             link = substr(blob, RSTART, RLENGTH)
    key = cal SUBSEP title SUBSEP link
    if (seen[key]++) next
    printf "%s\t%s\t%s\t%s\t%s\n", link, time, cal, title, desc
  }
'
