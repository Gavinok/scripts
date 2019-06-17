#!/bin/bash
pico2wave -w=/tmp/test.wav "$1"
aplay /tmp/test.wav -D 'pulse'
rm /tmp/test.wav
