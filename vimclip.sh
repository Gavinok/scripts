#!/usr/bin/env bash
~/hello.c
chmod +w ~/hello.c
"$TERMINAL" -e "$EDITOR" ~/hello.c
 cat ~/hello.c | xclip -i -selection c 
