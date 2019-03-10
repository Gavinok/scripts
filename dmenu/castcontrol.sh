#!/usr/bin/env sh

res=$(printf "play/pause\\nstop\\nnext\\nvup\\nmute\\nvdown\\nh(<)\\nl(>)\\nopen" | dmenu -l -i -p 'Cast Controls:'  ) 

case "$res" in
	play/pause) castnow --command space --exit >/dev/null 2>&1 & ;;
	stop) castnow --command s --exit >/dev/null 2>&1 & ;;
	next) castnow --command n --exit >/dev/null 2>&1 & ;;
	vup) castnow --command up --exit >/dev/null 2>&1 & ;;
	vdown) castnow --command down --exit >/dev/null 2>&1 & ;;
	mute) castnow --command m --exit >/dev/null 2>&1 & ;;
	h*)	castnow --command left --exit >/dev/null 2>&1 & ;;
	l*)	castnow --command right --exit >/dev/null 2>&1 & ;;
	open) st -g "=30x4-0+0" -e castnow >/dev/null 2>&1 & ;;
	*) exit
esac
