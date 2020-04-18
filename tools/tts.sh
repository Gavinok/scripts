#!/bin/bash
pico2wave -w=/tmp/test.wav "$1"
# For Pulse
# aplay /tmp/test.wav -D 'pulse'
# For Alsa
aplay /tmp/test.wav
rm /tmp/test.wav
