#!/usr/bin/env sh
# du -a $1* | awk '{print $2}' | fzf | xargs  -r $EDITOR ;
find "$1" -not -path "*/\.git*" -type f -print | fzf --bind "ctrl-o:execute-silent(xdg-open {}&)" | xargs  -r $EDITOR ;
