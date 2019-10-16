#!/usr/bin/env sh
# du -a ~/.scripts/* ~/.config/* | awk '{print $2}' | fzf --color="$SCHEME" | xargs  -r $EDITOR ;
find ~/.config/ ~/.scripts/ -path "*/.config/coc" -prune -o -path "*.git" -prune -o -print | fzf | xargs -r $EDITOR
