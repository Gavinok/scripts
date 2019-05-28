#!/bin/sh
#
# Write/remove a task to do later.
#
# Select an existing entry to remove it from the file, or type a new entry to
# add it.
#

file="$HOME/Dropbox/vimwiki/todo.txt"
touch "$file"
# $TERMINAL $EDITOR $file
$TERMINAL -n popup -t Todo $EDITOR $file
exit 0
