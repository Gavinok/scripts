#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : passgen.sh
# @created     : Sun 02 Feb 2020 09:32:36 AM MST
#
# @description : simple password generator
######################################################################

length=32
date +%s | sha256sum | base64 | head -c "${length}" ; echo

# vim: set tw=78 ts=2 et sw=2 sr:
