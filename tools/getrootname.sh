#bin/sh
rootwindtitle=$(xdotool search --maxdepth 0 "" 2>/dev/null)
xdotool getwindowname "$rootwindtitle"
