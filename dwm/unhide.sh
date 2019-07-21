#!/usr/bin/env bash

tmpfile="/tmp/hidden"
HIDDENWINDOWS=$(wc -l $tmpfile | cut -d " " -f1)

if [ "$HIDDENWINDOWS" -le "1" ];then
    WINDOWID=$(sed 's/@@@/ /g' "$tmpfile" | awk '{print $NF}' )
else
    WINDOWID=$(sed 's/@@@/ /g' "$tmpfile" | dmenu -p "Show" -l $HIDDENWINDOWS | awk '{print $NF}' )
fi

if [[ -n "$WINDOWID" ]]; then
    xdotool windowmap "$WINDOWID"
    sed -i '/'${WINDOWID}'/d' "$tmpfile"
    export WINDOWID=
else
    notify-send "No hidden windows"
fi
