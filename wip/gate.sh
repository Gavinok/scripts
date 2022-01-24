#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : gate.sh
# @created     : Tue 26 Jan 2021 11:08:19 AM
#
# @description : apply a noise gate to a video
######################################################################
# TODO: needs some work
ADDED_TEXT=POST
infile="$1"
tmpaudio=tmp.wav
tmpaudio2=tmp2.wav
outfile="${ADDED_TEXT}${infile}"
soundprofile="${HOME}/noise_profile_file"
minvol=-50
[ -f "$soundprofile" ] || soundprofile="$2"

ffmpeg -i "$infile" -vn -ac 1 -f wav "${tmpaudio}"
sox "${tmpaudio}" "${tmpaudio2}" \
  noisered "$soundprofile" 0.21 \
  compand .1,.2 -inf,-50.1,-inf,${minvol},${minvol} 0 -90 .1
ffmpeg -i "$infile" -i "${tmpaudio2}" -c:v copy -map 0:v:0 -map 1:a:0 "${outfile}"
ffplay -i  "${outfile}"
# vim: set tw=78 ts=2 et sw=2 sr:

