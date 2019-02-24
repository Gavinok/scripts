#!/bin/bash

split_checker()
{
	while true
	do
		# if we don't have a file, start at zero
		# if [ ! -f "/tmp/value.dat" ] ; then
		#   value=0
		# otherwise read the value from the file
		# else
		  value=`cat /tmp/value.dat`
		# fi
		if [[ $value == 1 ]];
		then
			echo "[V]"
			# i3-msg -q "split v"
		else
			echo "[>]"
			# i3-msg -q "split h"
		fi
		sleep 0.4
	done
}


if [ -f "/tmp/value.dat" ] ; then
	split_checker
else
	value=0
	echo "[>]"
	i3-msg -q "split h"
	# and save it for next time
	echo "${value}" > /tmp/value.dat
	split_checker
fi
