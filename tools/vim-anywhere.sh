#!/bin/dash
winid=$(xprop -root _NET_ACTIVE_WINDOW | sed 's/.*[[:space:]]//')
TEMPFILE=/tmp/VimFloat
while getopts ":c" o; do case "$o" in
	c) clip="1" ;; #output to clip
	*) printf "Invalid option: -%s\\n" "$o" && exit ;;
esac done
# Extract the output into variables
geom=$(xdotool getwindowgeometry "$(xdotool getactivewindow)" )
local=$(echo "$geom" | awk NR==2 | cut -d: -f 2 | cut -d\( -f 1)
dimentions=$(echo "$geom" | awk NR==3 | cut -d: -f 2 | cut -d\( -f 1 | cut -d, -f1)
x=$(echo "$local" | cut -d, -f1); 
y=$(echo "$local" | cut -d, -f2);
w=$(echo "$dimentions" | cut -dx -f1)
h=$(echo "$dimentions" | cut -dx -f2)
> $TEMPFILE
st -t 'vim-anywhere' -n 'popup' -e "$EDITOR" -c 'startinsert' $TEMPFILE
xsel -i -b < $TEMPFILE
if [ -z $clip ] ;then
    text=$(xsel -o)
    layout=$(setxkbmap -query | awk '/^layout:/{ print $2 }')
    setxkbmap -layout us
    #move mouse to center of window
    xdotool mousemove $((x + w/2)) $((y + h/2))
    xdotool type  --clearmodifiers "$text"
    setxkbmap -layout "$layout"
    #uses my remaps script to remap capslock back to ctrl and escape
    remaps
fi

