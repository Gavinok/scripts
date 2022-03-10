#!/usr/bin/env sh
# basis for this comes from
#     https://github.com/flameshot-org/flameshot/issues/172
[ $# -lt 2 ] && \
  echo 'You have to pass a duration in seconds and a filename: "gif.sh 10 /tmp/record.gif"' && \
  exit 1

function is-installed() {
    if [ ! command -v "$1" ] > /dev/null; then
	echo "please install $1 first"
	exit 2
    fi
}

is-installed "byzanz-record"
is-installed "slop"

byzanz-record                                        \
  --cursor                                           \
  --verbose                                          \
  --delay=2                                          \
  --duration=${1}                                    \
  $(slop -f "--x=%x --y=%y --width=%w --height=%h")  \
  "${2}"
