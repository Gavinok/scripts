#!/bin/bash
export FZF_DEFAULT_COMMAND="find . -path '*/\.*' -type d -prune -o -type f -print -o -type l -print 2> /dev/null | sed s/^..//"

target=$(fzf)
[ -z "$target" ] && exit 0
if [ "${target: -5}" == ".docx" ]; then
	lowriter --convert-to pdf "${target}" --outdir "${prompt}" &
	exit 0
fi
#check if it can be edited
isFile=$(file -0 "$target" | cut -d $'\0' -f2)
case "$isFile" in
   (*text*)
	  exec $EDITOR "$target" 
	  ;;
   (*)
	  echo "$target is not a text file, please use a different file"
	  exec xdg-open "${target}" &
	  ;;
esac

