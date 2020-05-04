#!/bin/sh
#
# Write/remove a task to do later.
#
# Select an existing entry to remove it from the file, or type a new entry to
# add it.
#

ORGFILE="$HOME/Documents/org/mylife.org"
# $TERMINAL $EDITOR $file
$TERMINAL -n popup -t Todo -e "$EDITOR" "$ORGFILE"
exit 0
