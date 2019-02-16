#!/bin/sh
# TODO: multisel

target="$1"
[ -z "$target" ] && target="$(realpath .)"
prompt="$2"

while true; do
	p="$prompt"
	[ -z "$p" ] && p="$target"
	sel="$(ls -1a "$target" |grep -v '^\.$' | dmenu -i -p "$p" -l 25)"
	ec=$?
	[ "$ec" -ne 0 ] && exit $ec

	c="$(echo "$sel" |cut -b1)"
	if [ "$c" = "/" ]; then
		newt="$sel"
	else
		newt="$(realpath "${target}/${sel}")"
	fi

	if [ -e "$newt" ]; then
		target="$newt"
		if [ ! -d "$target" ]; then
			echo "$target"
			isFile=$(file -0 "$target" | cut -d $'\0' -f2)
			case "$isFile" in
			   (*text*)
				  echo "$attachment is a text file"
				  exec st -e $EDITOR $target
				  ;;
			   (*)
				  echo "$isFile is not a text file, please use a different file"
				  exec xdg-open $target
				  ;;
			esac

			exit 0
		fi
	fi
done
