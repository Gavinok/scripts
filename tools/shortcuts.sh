#!/bin/bash
# Output locations. Unactivated progs should go to /dev/null.
# Credit yo the original creator:
# Luck Smith
# https://github.com/LukeSmithxyz/voidrice
shell_shortcuts="${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc"
ranger_shortcuts="${XDG_CONFIG_HOME:-$HOME/.config}/ranger/shortcuts.conf"
qute_shortcuts="/dev/null"
fish_shortcuts="${XDG_CONFIG_HOME:-$HOME/.config}/fish/shortcuts.fish"
vifm_shortcuts="${XDG_CONFIG_HOME:-$HOME/.config}/vifm/vifmshortcuts"
vim_shortcuts="$HOME/.vim/vimshortcuts.vim"

# Remove, prepare files
rm -f "$ranger_shortcuts" "$qute_shortcuts" 2>/dev/null
printf "# vim: filetype=sh\\n" > "$fish_shortcuts"
printf "# vim: filetype=sh\\n" > "$shell_shortcuts"
printf "\" vim: filetype=vim\\n" > "$vifm_shortcuts"
printf "\" vim: filetype=vim\\n" > "$vim_shortcuts"

# Format the `bmdirs` file in the correct syntax and sent it to all three configs.
sed "s/\s*#.*$//;/^\s*$/d" "$HOME/.config/bmdirs" | tee >(awk '{print "alias " $1"=\"cd "$2" && ls -a\" "}' >> "$shell_shortcuts") \
	>(awk '{print "abbr", $1, "\"cd " $2 "; and ls -a\""}' >> "$fish_shortcuts") \
	>(awk '{print "map g" $1, ":cd", $2 "<CR>\nmap t" $1, "<tab>:cd", $2 "<CR><tab>\nmap M" $1, "<tab>:cd", $2 "<CR><tab>:mo<CR>\nmap Y" $1, "<tab>:cd", $2 "<CR><tab>:co<CR>" }' >> "$vifm_shortcuts") \
	>(awk '{print "config.bind(\";"$1"\", \"set downloads.location.directory "$2" ;; hint links download\")"}' >> "$qute_shortcuts") \
	>(awk '{print "nmap <leader>g" $1, ":e", $2 "<CR>" }' >> "$vim_shortcuts") \
	| awk '{print "map g"$1" cd "$2"\nmap t"$1" tab_new "$2"\nmap m"$1" shell mv -v %s "$2"\nmap Y"$1" shell cp -rv %s "$2}' >> "$ranger_shortcuts"

# Format the `configs` file in the correct syntax and sent it to both configs.
sed "s/\s*#.*$//;/^\s*$/d"  "$HOME/.config/bmfiles" | tee >(awk '{print "alias "$1"=\"$EDITOR $(readlink "$2"||echo "$2")\" "}' >> "$shell_shortcuts") \
	>(awk '{print "abbr", $1, "\"$EDITOR $(readlink "$2")\""}' >> "$fish_shortcuts") \
	>(awk '{print "map", $1, ":e", $2 "<CR>" }' >> "$vifm_shortcuts") \
	>(awk '{print "nmap <leader>"$1, ":e <c-r>=resolve(expand(\"",$2"\"))<CR><CR>"}' >> "$vim_shortcuts") \
	| awk '{print "map "$1" shell $EDITOR "$2}' >> "$ranger_shortcuts"
