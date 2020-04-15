#!/usr/bin/dash
eval $(xdotool getmouselocation --shell)
prim="$(xclip -o)"

#file
if [ -f "$prim" ]; then
	func=$(printf 'vim\nopen\n' | jgmenu --no-spawn --simple)
	case $func in
	vim)
		st -e "$EDITOR" "$prim"
		;;
	open)
		xdg-open "$prim"
		;;
	esac
	exit
fi

#url
if echo "$prim" | grep "^.*\.[A-Za-z]\+.*" >/dev/null; then
	func=$(printf 'open\nurl\nkde\ndhandler\n' | jgmenu --no-spawn --simple)
	case $func in
	open)
		setsid "$BROWSER" "$prim" &
		exit
		;;
	url)
		setsid "$TRUEBROWSER" "$prim" &
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
	*) echo fail ;;
	esac
	exit
fi

#etc
func=$(printf 'search\n' | jgmenu --no-spawn --simple)
case $func in
search)
	setsid $BROWSER "https://duckduckgo.com/?q=$prim" &
	exit
	;;
*) echo fail ;;
esac
exit
#vim:ft=sh
