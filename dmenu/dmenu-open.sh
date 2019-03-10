#!/bin/bash
# This script is used to interact with dbrowse.sh and 
# open files in different programs
target=$(dbrowse.sh)
[ -z "$target" ] && exit 0
if [ "${target: -5}" == ".docx" ]; then
	lowriter --convert-to pdf "${target}" --outdir "${prompt}" &
	exit 0
fi
#check if it can be edited
isFile=$(file -0 "$target" | cut -d $'\0' -f2)
case "$isFile" in
   (*text*)
	  echo "$attachment is a text file"
	  exec st -e $EDITOR "$target" &
	  ;;
   (*)
	  echo "$target is not a text file, please use a different file"
	  exec xdg-open "${target}" &
	  ;;
esac

