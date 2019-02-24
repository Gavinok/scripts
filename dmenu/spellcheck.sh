# This is a simple script that utilises dmenu to 
# check the spelling of a word using aspell.
# After a selection has been made it will use xclip
# to copy to clipboard.
word=$(echo "?" | dmenu -i -p 'spell')

if [ "$word" != "?" ]; then
echo "$word" | aspell pipe --suggest | sed -e '1d' |sed 's/^[^:]*://g' | sed -e $'s/,/\\\n/g' | dmenu -p 'copy' | xclip -selection clipboard

pgrep -x dunst >/dev/null && notify-send "$(xclip -o -selection clipboard) copied to clipboard."
fi






