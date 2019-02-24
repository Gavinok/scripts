if  pgrep -x $1 ;
then
	killall $1
	exit
fi
exec $1
