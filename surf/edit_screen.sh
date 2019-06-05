#!/bin/sh
tmpfile=$(mktemp /tmp/st-edit.XXXXXX.html)
trap  'rm "$tmpfile"' 0 1 15
cat > "$tmpfile"
$TERMINAL -e "$EDITOR" "$tmpfile"
