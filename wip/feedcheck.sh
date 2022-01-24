#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : feedcheck.sh
# @created     : Mon 11 Jan 2021 08:07:36 PM
#
# @description : check rss feed
######################################################################

CACHEDIR="$XDG_CACHE_HOME/sfeed"
mkdir -p "$CACHEDIR"
UNREAD_CACHE="$CACHEDIR/unread_sfeed"
READ_CACHE="$CACHEDIR/read_sfeed"
TMPFILE=/tmp/sfeed_nodup
FEEDDIR="$HOME/.sfeed/feeds"
awkcmd='NR==FNR {
    a[$0]++
    next
}

! ($0 in a) {
    print
}'
update_cache()
{
  sfeed_plain $FEEDDIR/* | grep '^N' >> "$UNREAD_CACHE"
  awk '!a[$0]++' "$UNREAD_CACHE" > "$TMPFILE"
  selected=$(awk "$awkcmd" "$READ_CACHE" "$TMPFILE" | dmenu -l 10)
  test -n "$selected" && echo "$selected" >> "$READ_CACHE"
  url=$(echo "$selected" | sed -n 's@^.* \([a-zA-Z]*://\)\(.*\)$@\1\2@p')
  test -n "$url" && $BROWSER "$url"
  rm "$TMPFILE"
}

update_cache
# vim: set tw=78 ts=2 et sw=2 sr:

