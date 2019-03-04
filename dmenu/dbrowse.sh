#!/bin/sh
# TODO: multisel
# This is a simple script that starts at $HOME by default
# or any other location based on the first argument. 
# The secound arg will be the prompt you can then select 
# a directory to enter until you reach a file whech is 
# then printed to stdout
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
			exit 0
		fi
	fi
done
