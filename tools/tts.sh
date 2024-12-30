#!/bin/bash
# Biggest issue with this approach is you need to be online to use it :(
# depends on
# - python-gtts (gtts-cli)
# - ffmpeg (speeding up and play audio )

TMPFILE=$(mktemp XXX.mp3)
# TMPFILE2=$(mktemp XXXY.mp3)
trap 'rm $TMPFILE' EXIT TERM HUP
# trap 'rm $TMPFILE2' EXIT TERM HUP

# # Test for Palse Audio or Default to Alsa
# ps -C pulseaudio 2>&1 >/dev/null
# test [ $? == 0 ] && FLAGS="-D 'pulse'" || FLAGS=""
echo "$*" | piper-tts --model /usr/share/piper-voices/en/en_US/danny/low/en_US-danny-low.onnx -f "$TMPFILE"
mpv "$TMPFILE"

# gtts-cli "$1" | ffplay -autoexit -nodisp -hide_banner -loglevel quiet -f mp3 -i pipe: -af "atempo=1.33"
# Modified to force every line to be read in one at a time. Seems to
# prevent most of the errors I have faced with this
