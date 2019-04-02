#!/usr/bin/sh
# a simple todo script that integrates with calcurse
EXECUTABLE='python2.7 /home/gavinok/tasky.py'
PROMPT='to do:'
createtodo(){
	newtodo=$(echo "?" | dmenu -p "Enter the new TODO item:")
	[ -z $newtodo ] || [ $newtodo = "?" ] &&  exit
	tasklist=$(echo "?" | dmenu -p "Select Tasklist")
	[ -z $tasklist ] || [ $tasklist = "?" ] &&  tasklist=0
	date=$(echo "?" | dmenu -p "Enter date MM/DD/YYYY:")
	if [ -z $date ] || [ $date = "?" ]; then
		$EXECUTABLE -a --tasklist $tasklist --title "$newtodo"
	else
		$EXECUTABLE -a --tasklist $tasklist --title "$newtodo" -d "$date"
	fi;
	exit
}
toggle(){
	completed=$(echo $1 | grep -o '[0-9]\+' )
	$EXECUTABLE -t -i $completed | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
	exit
}
mkdir "/tmp/dmenu_todo/"
touch "/tmp/dmenu_todo/tmp.txt"
echo "New Todo" > /tmp/dmenu_todo/tmp.txt
$EXECUTABLE -l | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tail -n +2 >> /tmp/dmenu_todo/tmp.txt
echo "clear" >> /tmp/dmenu_todo/tmp.txt
completed=$(cat /tmp/dmenu_todo/tmp.txt | dmenu -l 10 -p "$PROMPT" |  sed 's/[0-9]. //g')
[ -z "$completed" ] &&  exit
[ "$completed" = "New Todo" ] && createtodo
[ "$completed" = "clear" ] &&  $EXECUTABLE -c
toggle $completed
