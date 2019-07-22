#!/usr/bin/env sh

du -a ~/.scripts/* ~/.config/* | awk '{print $2}' | fzf --color="$SCHEME" | xargs  -r $EDITOR ;

