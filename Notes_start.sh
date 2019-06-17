#!/usr/bin/sh

NOTEBOOK=~/Dropbox/vimwiki/

init(){
    mkdir -p $NOTEBOOK
}

new(){
    file=$(find $NOTEBOOK -name "*" | fzf)
    file=$(find $NOTEBOOK -name "*" | fzf)
    $EDITOR "$file"
}

edit(){
    file=$(find $NOTEBOOK -name "*" | fzf)
    $EDITOR "$file"
}

while getopts ":n:e" o; do case "$o" in
	n) new "$*";;
	e) edit;;
	*) printf "Invalid option: -%s\\n" "$o" && exit ;;
esac done

