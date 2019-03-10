#!/bin/bash
# Quick and dirty way to convert txt from your clipboard 
# into a QR code
clipmenu
xclip -selection "primary" -o |  qrencode -s 10 -o /tmp/QR.png 
xdg-open /tmp/QR.png


