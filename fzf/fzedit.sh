#!/bin/sh
# du -a $1* | awk '{print $2}' | fzf | xargs  -r $EDITOR ;
file=$(find "$1" -not -path "*/\.git*" -type f -print | fzf --bind "ctrl-o:execute-silent(setsid xdg-open {}&)")
[ -e "$file" ] && ${EDITOR:-vi} "$file"
