#!/bin/dash
#
# Write/remove a task to do later.
#
# Select an existing entry to remove it from the file, or type a new entry to
# add it.
#

ORGDIR="$HOME ~/Documents/org/"
# $TERMINAL $EDITOR $file
$TERMINAL -n popup -t Todo "$EDITOR" -c "silent grep! -r TODO $ORGDIR"
exit 0
