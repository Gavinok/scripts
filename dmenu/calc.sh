#!/usr/bin/env bash

# https://github.com/onespaceman/menu-calc
# Calculator for use with rofi/dmenu(2)
# Copying to the clipboard requires xclip

usage() {
    echo "$(tput bold)menu-calc$(tput sgr0)"
    echo "A calculator for Rofi/dmenu(2)"
    echo
    echo "$(tput bold)Usage:$(tput sgr0)"
    echo "    = 4+2"
    echo "    = (4+2)/(4+3)"
    echo "    = 4^2"
    echo "    = sqrt(4)"
    echo "    = c(2)"
    echo
    echo "$(tput bold)Force Rofi/dmenu(2):$(tput sgr0)"
    echo "By default, if rofi exists, it will be used. To force menu-calc to"
    echo "use one or the other, use the --dmenu argument"
    echo
    echo "    = --dmenu=<dmenu_executable>"
    echo
    echo "$(tput bold)Passing arguments to Rofi/dmenu(2):$(tput sgr0)"
    echo "Any parameters after ' -- ' will be passed to Rofi/dmenu(2)."
    echo
    echo "    = -- <Rofi/dmenu(2) args>"
    echo
    echo "The answer can be copied to the clipboard and used for further calculations inside (or outside) Rofi/dmenu."
    echo
    echo "If launched outside of Rofi/dmenu the expression may need quotation marks."
    exit
}

# Process CLI parameters
for var in "$@"
do
    case $var in
        -h|--help) usage ;;
        -d=*|--dmenu=*)
            menu=$(echo $var | cut -d'=' -f 2);
            ;;
    esac
done

# Grab the answer
answer=$(echo "$1" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')

# Path to menu application
if [ ! -n "${menu+1}" ]; then
    if [[ -n $(command -v rofi) ]]; then
        menu=$(command -v dmenu)
    else
        echo >&2 "Rofi or dmenu not found"
        exit
    fi
fi

# If using rofi, add the necessary parameters
if [[ $menu == "rofi" || $menu == $(command -v rofi) ]]; then
    menu="$menu -dmenu -lines 3"
elif [[ $menu == "dmenu" || $menu == $(command -v dmenu) ]]; then
    menu="$menu ""$DMENU_OPTIONS"
fi

# Determine args to pass to dmenu/rofi
while [[ $# -gt 0 && $1 != "--" ]]; do
    shift
done
[[ $1 == "--" ]] && shift

action=$(echo -e "Copy to clipboard\nClear\nClose" | $menu "$@" -p "= $answer")

case $action in
    "Clear") $0 "--dmenu=$menu" "--" "$@" ;;
    "Copy to clipboard") echo -n "$answer" | xclip -selection clipboard ;;
    "Close") ;;
    "") ;;
    *) $0 "$answer $action" "--dmenu=$menu" "--" "$@" ;;
esac
