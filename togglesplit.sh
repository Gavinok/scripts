#!/bin/sh

# if we don't have a file, start at zero
if [ ! -f "/tmp/value.dat" ] ; then
	value=0
	i3-msg -q "split h"
# otherwise read the value from the file
else
	value=`cat /tmp/value.dat`
fi

if [[ $value == 1 ]];
then
	# notify-send -t 500 -a i3 "🡒 Horizontal"
	i3-msg -q "split h"
	value=`expr ${value} - 1`
else
	# notify-send -t 500 -a i3 "🡓 Vertical"
	i3-msg -q "split v"
	value=`expr ${value} + 1`
fi

# and save it for next time
echo "${value}" > /tmp/value.dat
