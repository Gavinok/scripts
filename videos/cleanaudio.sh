#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : cleanaudio.sh
# @created     : Wed 26 Aug 2020 11:03:44 AM
#
# @description : remove background hissing from audio
# @requires    : sox and ffmpeg
######################################################################

[ ! -f "$1" ] && exit
OGVIDEOFILE="$1"

# This Is Used For Removing Background Noise
# generate it by finding a section of your video that 
# has *only* background noise. then remove it using ffmpeg
# like so:
# ffmpeg -i AUDIOFILE.mp3 -ss 00:00:18 -t 00:00:20 noisesample.wav
# Then create the profile using this command:
# sox noisesample.wav -n noiseprof noise_profile_file
# This can be exported in your bashrc
[ -f "$SOUNDPROFILE" ] || SOUNDPROFILE="$2"

[ ! -f "$SOUNDPROFILE" ] && exit

# Remove Audio From Video
ffmpeg -i "$OGVIDEOFILE" -vn -ac 2 -ar 44100 -ab 320k -f mp3 AUDIOFILE.mp3

# Remove Background Noise
sox AUDIOFILE.mp3 fixedAUDIOFILE.mp3 noisered $SOUNDPROFILE 0.25

# Join Audio And Video
ffmpeg -i "$OGVIDEOFILE" -i fixedAUDIOFILE.mp3 -c:v copy -map 0:v:0 -map 1:a:0 "${OGVIDEOFILE}NEW.mp4"

rm fixedAUDIOFILE.mp3

notify-send "${OGVIDEOFILE}NEW.mp4 has been created"

# vim: set tw=78 ts=2 et sw=2 sr:
