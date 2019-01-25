#!/bin/bash
echo "$1"
H=$(date +%H)
if [[ -n "$3" ]];then
	echo $1 is not empty
	echo " is it after $2 and before $3?"
	if (( $2 <= 10#$H && 10#$H < $3 )); then 
		echo between $2 and $3
	fi
fi

if (( $2 <= 10#$H )); then
	if  [[ -z "$3" ]]; then
		echo after $2
	fi
else
	echo "no"
fi

