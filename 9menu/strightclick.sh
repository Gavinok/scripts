#!/usr/bin/env zsh
eval `xdotool getmouselocation --shell`
prim="$(xclip -o)"
#file
[ -f "$prim" ] && 9menu -bg black -fg white -warp -popup -geometry 100x100+${X}+${Y} -popup  "vim:st -e $EDITOR $prim" && exit
#url
if echo "$prim" | grep "^.*\.[A-Za-z]\+.*" >/dev/null; then
    func=$(9menu -bg black -fg white -warp -popup \
    -geometry 100x100+${X}+${Y} \
     "open:echo open" "browser:echo url" "kdeconnect:echo kde" "dhandler:echo dhandler" "hide:exit")
    case $func in
        open) 
	    setsid "$BROWSER" "$prim" &
	    exit
    	;;
        url)
	    setsid $TRUEBROWSER "$prim" &
	    exit
    	;;
        kde)
	    kdeconnect-handler "$prim"
	    exit
    	;;
        dhandler)
	    dmenuhandler "$prim"
	    exit
    	;;
	*) echo fail
    esac
    exit
fi
#etc
9menu -bg black -fg white -warp -popup -geometry 100x100+${X}+${Y} -popup "search:$BROWSER https://duckduckgo.com/?q=$prim" 
