#!/bin/dash

# This is a simple script that utilises dmenu to 
# check the spelling of a word using aspell.
# After a selection has been made it will use xclip
# to copy to clipboard.

LAUNCER="dmenu"

word=$(echo "?" | $LAUNCER -i -p 'spell')

if [ -n "$word" ] && [ "$word" != "?" ]; then
    selection=$(echo "$word" | aspell pipe --suggest | sed -e '1d; s/^[^:]*://g; s/, /\n/g; s/^ //' | $LAUNCER -p 'copy' )
    [ -z "$selection" ]  && exit
	[ "$selection" = "*" ] && printf "%s" "$selection" | xclip -selection clipboard
    printf "%s" "$selection" | xclip -selection clipboard
    printf "%s" "$selection" | xclip -selection primary
    pgrep -x dunst >/dev/null && notify-send "$(xclip -o -selection clipboard) copied to clipboard."
fi
exit
