#!/bin/bash
# quick and dirty way to copy your clipboard into a QR code
xclip -selection "primary" -o |  qrencode -s 10 -o /tmp/QR.png 
xdg-open /tmp/QR.png


