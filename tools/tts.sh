#!/bin/bash

TMPFILE=$(mktemp XXX.wav)
trap 'rm $TMPFILE' EXIT TERM HUP

# Test for Palse Audio or Default to Alsa
ps -C pulseaudio 2>&1 >/dev/null
test [ $? == 0 ] && FLAGS="-D 'pulse'" || FLAGS=""

#Convert first parameter to wavefile then play with autocleanup
pico2wave -w=$TMPFILE -- "$1"
aplay $TMPFILE $FLAGS
