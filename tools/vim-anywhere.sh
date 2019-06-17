#!/bin/dash
winid=$(xprop -root _NET_ACTIVE_WINDOW | sed 's/.*[[:space:]]//')
notify-send $winid
TEMPFILE=/tmp/VimFloat
while getopts ":c" o; do case "$o" in
	c) clip="1" ;; #output to clip
	*) printf "Invalid option: -%s\\n" "$o" && exit ;;
esac done
local=$(xdotool getwindowgeometry $(xdotool getactivewindow) | awk NR==2 | cut -d: -f 2 | cut -d\( -f 1)
x=$(echo $local | cut -d, -f1); 
y=$(echo $local | cut -d, -f2);
> $TEMPFILE
st -t 'vim-anywhere' -n 'popup' -e "$EDITOR" -c 'startinsert' $TEMPFILE
xsel -i < $TEMPFILE
if [ -z $clip ] ;then
    text=$(xsel -o)
    layout=$(setxkbmap -query | awk '/^layout:/{ print $2 }')
    setxkbmap -layout us
    xdotool mousemove $x $y
    xdotool type  --clearmodifiers "$text"
    setxkbmap -layout "$layout"
    remaps
fi

