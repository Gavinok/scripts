#!/bin/sh
# du -a ~/.scripts/* ~/.config/* | awk '{print $2}' | fzf --color="$SCHEME" | xargs  -r $EDITOR ;
file=$(find ~/.config/ ~/.scripts/ -path "*/.config/coc" -prune -o -path "*.git" -prune -o -print | fzf --bind "ctrl-o:execute-silent(xdg-open {}&)")
[ -e "$file" ] && ${EDITOR:-vi} $file
