#!/bin/bash
echo "$1"
H=$(date +%k)
echo "$H"
if [[ -n "$3" ]];then
	echo $1 is not empty
	echo "is it after $2 and before $3?"
	if (( $2 <= $H && $H < $3 )); then 
		$1
	else
		echo no
	fi
	
fi     

if (( $2 <= $H )); then
	if  [[ -z "$3" ]]; then
		echo after $2
		$1
	fi
else
	echo "no"
fi

