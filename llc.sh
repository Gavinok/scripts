#!/bin/bash

# A general audio interface for LARBS.


[ -z "$2" ] && num="2" || num="$2"

case "$1" in
	u*) xbacklight -inc "$num"% ; notifybrightness;;#change the default audio sync
	d*) xbacklight -dec "$num"% ; notifybrightness;;#change the default audio sync
	*) cat << EOF

Allowed options:
  up NUM	Increase brightness (2 secs default)
  down NUM	Decrease brightness (2 secs default)
  all else	Print this message

All of these commands, except for \`truemute\`, \`prev\` and \`play\` can be truncated,
i.e. \`lmc r\` for \`lmc restart\`.
EOF
esac
