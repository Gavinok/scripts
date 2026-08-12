#!/bin/sh
# Depends on `tesseract` a commandline Optical Character Recognition
# tool
TMPTEXTFILE=$(mktemp XXX.txt)
trap 'rm $TMPTEXTFILE' EXIT TERM HUP


IMGFILE=$(windowshot.sh c)
echo $IMGFILE
trap 'rm $IMGFILE' EXIT TERM HUP

tesseract $IMGFILE "${TMPTEXTFILE%.*}"

TEXT=$(cat $TMPTEXTFILE)
tts.sh "$TEXT"
