#!/usr/bin/sh
# printf "%b,%b" "$(xdotool getwindowname "$(xdotool getwindowfocus)")" "$(xdotool windowunmap "$(xdotool getwindowfocus)")" >> $HOME/hidden
WINDOWID="$(xdotool getwindowfocus)"
xdotool set_window --classname "float" "$WINDOWID"
xdotool windowunmap "$WINDOWID"
printf "%b@@@%b\\n" "$(xdotool getwindowname "$WINDOWID")" "$WINDOWID" >> "/tmp/hidden"
