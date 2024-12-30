#!/bin/sh
TMPTEXTFILE=$(mktemp XXX.txt)
trap 'rm $TMPTEXTFILE' EXIT TERM HUP

IMGFILE=$(windowshot.sh c 2> /dev/null )
echo $IMGFILE
trap 'rm $IMGFILE' EXIT TERM HUP

tesseract $IMGFILE "${TMPTEXTFILE%.*}"

TEXT=$(cat $TMPTEXTFILE)
echo "$TEXT" | xclip
