#!/bin/sh
emacsclient -a "" -c --eval "(message-mailto \"$@\")"
