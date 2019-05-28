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
	p) progsfile=${OPTARG} ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;
esac done

[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/archi3/progs.csv"
name=$(whoami)

# DEFAULTS:
[ -z "$dotfilesrepo" ] && dotfilesrepo="https://github.com/Gavinok/dotfiles.git"
[ -z "$scriptrepo" ] && scriptrepo="https://github.com/Gavinok/scripts.git"

### FUNCTIONS ###

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}

# Program Installation ====================
refreshkeys() { \
	pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
}
# if -x 
gitmakeinstall() {
	dir=$(mktemp -d)
	dialog --title "LARBS Installation" --infobox "Installing \`$(basename "$1")\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
	cd "$dir" || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return ;
}

manualinstall() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[ -f "/usr/bin/$1" ] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	cd /tmp || exit
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
	cd /tmp || return) ;
}
# if arch linux or manjaro
# manualinstall $aurhelper || error "Failed to install AUR helper."

gitmakeinstall() {
	dir=$(mktemp -d)
	dialog --title "LARBS Installation" --infobox "Installing \`$(basename "$1")\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
	cd "$dir" || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return ;
}

aurinstall() { \
	dialog --title "LARBS Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2" 5 70
	echo "$aurinstalled" | grep "^$1$" >/dev/null 2>&1 && return
	sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1
}

pipinstall() { \
	dialog --title "LARBS Installation" --infobox "Installing the Python package \`$1\` ($n of $total). $1 $2" 5 70
	command -v pip || pacman -S --noconfirm --needed python-pip >/dev/null 2>&1
	yes | pip install "$1"
}
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
	dialog --infobox "Enabling \"$service\"..." 4 40
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
    # Check if user is root on Arch distro. Install dialog.
    pacman -Syu --noconfirm  ||  error "Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"

    # Refresh Arch keyrings.
    refreshkeys || error "Error automatically refreshing Arch keyring. Consider doing so manually."

    pacman --noconfirm --needed -S base-devel git >/dev/null 2>&1
    [ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case

    # Allow user to run sudo without password. Since AUR programs must be installed
    # in a fakeroot environment, this is required for all builds with AUR.
    newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

    # Make pacman and yay colorful and adds eye candy on the progress bar because why not.
    grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color/Color/" /etc/pacman.conf
    grep "ILoveCandy" /etc/pacman.conf >/dev/null || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

    # Use all cores for compilation.
    sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

    manualinstall $aurhelper || error "Failed to install AUR helper."

    # The command that does all the installing. Reads the progs.csv file and
    # installs each needed program the way required. Be sure to run this only after
    # the user has been created and has priviledges to run sudo without a password
    # and all build dependencies are installed.
    installationloop

    # Install the dotfiles in the user's home directory
    putgitrepo "$dotfilesrepo" "$HOME"
    rm -f "$HOME/README.md" "$HOME/LICENSE"
    putgitrepo "$scriptrepo" "$HOME/.scripts"

    # Pulseaudio, if/when initially installed, often needs a restart to work immediately.
    [ -f /usr/bin/pulseaudio ] && resetpulse

    # Enable services here.
    serviceinit NetworkManager cronie
    #check all programs are installed
    #allow all sudo privleges
    systembeepoff

    sudo mv -i /etc/hosts /etc/hosts-
    sudo curl -fo https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts /etc/hosts
fi



finalize
clear
