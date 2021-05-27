#!/bin/sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : f.sh
# @created     : Fri 17 Jan 2020 09:35:29 AM MST
#
# @description : fzf shortcuts
######################################################################

fzedit(){
  file=$(find "$@" -not -path "*/\.nnn*" -not -path "*/\.git*" -type f -print | fzf --bind "ctrl-o:execute-silent(setsid xdg-open {}&)")
  [ -e "$file" ] && ${EDITOR:-vi} "$file"
}

# TODO: automate adding these
f() {
	case "$*" in
	d)
		fzedit ~/Documents/
		;;
	D)
		fzedit ~/Downloads/
		;;
	v)
		fzedit ~/.vim/
		;;
	p)
		fzedit ~/Programming/
		;;
	w)
		fzedit ~/.local/Dropbox/DropsyncFiles/vimwiki/
		;;
	m)
		fzedit ~/.config/nnn/mounts/ 
		;;
	s)
    fzedit ~/.scripts/ ~/.config/
		;;
	*)
		fzedit .
		;;
	esac
}

f "$*"
# vim: set tw=78 ts=2 et sw=2 sr:
