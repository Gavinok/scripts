#!/bin/dash

# A general backlight interface
notifybrightness(){
    BRIGHTNESS=$(bright)
    # dunstify -t 500 -r 325 "Light: $BRIGHTNESS"
    # xsetroot -name "Light[$BRIGHTNESS]"
    ~/Programming/C_practice/statwe/statwe -b
}

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
