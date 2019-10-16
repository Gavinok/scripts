#!/usr/bin/env sh
# du -a $1* | awk '{print $2}' | fzf | xargs  -r $EDITOR ;
find "$1" -not -path "*/\.*" -type f -print | fzf | xargs  -r $EDITOR ;
