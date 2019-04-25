#!/bin/sh
# Luke's Auto Rice Boostrapping Script (LARBS)
# by Luke Smith <luke@lukesmith.xyz>
# License: GNU GPLv3

# Notes from Gavin
# I am making a personal version of this script it is still a work in progress
### OPTIONS AND VARIABLES ###

while getopts ":r:h:s" o; do case "${o}" in
	h) printf "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message\\n" && exit ;;
	r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" || exit ;;
	s) scriptrepo=${OPTARG} && git ls-remote "$scriptrepo" || exit ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;
esac done
name=$(whoami)

# DEFAULTS:
[ -z "$dotfilesrepo" ] && dotfilesrepo="https://github.com/Gavinok/dotfiles.git"
[ -z "$scriptrepo" ] && scriptrepo="https://github.com/Gavinok/scripts.git"

### FUNCTIONS ###

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}


putgitrepo() { # Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
	echo "Downloading and installing config files..." 4 60
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2" && chown -R "$name:wheel" "$2"
	# chown -R "$name:wheel" "$dir"
	git clone --depth 1 "$1" "$dir/gitrepo" >/dev/null 2>&1 &&
	cp -rfT "$dir/gitrepo" "$2"
	}
### THE ACTUAL SCRIPT ###

### This is how everything happens in an intuitive format and order.

# Install the dotfiles in the user's home directory
putgitrepo "$dotfilesrepo" "$HOME"
rm -f "$HOME/README.md" "$HOME/LICENSE"
putgitrepo "$scriptrepo" "$HOME/.scripts"

finalize
clear
