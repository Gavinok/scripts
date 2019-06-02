#!/bin/sh
# Luke's Auto Rice Boostrapping Script (LARBS)
# by Luke Smith <luke@lukesmith.xyz>
# License: GNU GPLv3

# Notes from Gavin
# I am making a personal version of this script it is still a work in progress
### OPTIONS AND VARIABLES ###

while getopts ":r:h:s:p" o; do case "${o}" in
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

### THE ACTUAL SCRIPT ###

### This is how everything happens in an intuitive format and order.

putgitrepo() { # Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
	echo "Downloading and installing config files..." 4 60
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2" && chown -R "$name:wheel" "$2"
	# chown -R "$name:wheel" "$dir"
	git clone --depth 1 "$1" "$dir/gitrepo" >/dev/null 2>&1 &&
	cp -rfT "$dir/gitrepo" "$2"
}

# if arch or manjaro
serviceinit() { for service in "$@"; do
	systemctl enable "$service"
	systemctl start "$service"
	done ;
}

OS="$(uname -o)" # this is for use with termux
if [ "$OS" = 'Android' ];then
    name=$(whoami)
    # Install the dotfiles in the user's home directory
    putgitrepo "$dotfilesrepo" "$HOME"
    rm -f "$HOME/README.md" "$HOME/LICENSE"
    putgitrepo "$scriptrepo" "$HOME/.scripts"

    [ -f "$HOME/.config/termuxlocalprofile" ] && mv -i  "$HOME/.config/termuxlocalprofile" "$HOME/.config/localprofile"
    [ -f "$HOME/.config/termuxvimlocal" ] && mv -i "$HOME/.config/termuxvimlocal" "$HOME/.config/vimlocal"
    pkg install curl git python python-dev zsh wget ranger nnn nvim
else
    # Install the dotfiles in the user's home directory
    putgitrepo "$dotfilesrepo" "$HOME"
    rm -f "$HOME/README.md" "$HOME/LICENSE"
    putgitrepo "$scriptrepo" "$HOME/.scripts"

    sudo mv -i /etc/hosts /etc/hosts-
    curl -fo https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts > /tmp/hosts 
    sudo mv /tmp/hosts /etc/hosts
fi



finalize
clear
