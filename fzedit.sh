#!/usr/bin/env sh
du -a $1* | awk '{print $2}' | fzf | xargs  -r $EDITOR  && cd;
