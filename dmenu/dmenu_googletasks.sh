#!/usr/bin/sh
# a simple todo script that integrates with calcurse
EXECUTABLE='python2.7 /home/gavinok/tasky.py'
PROMPT='to do:'
# function: createtodo 
# description: used to create a new task
createtodo(){
	newtodo=$(echo "?" | dmenu -p "Enter the new TODO item:")
	[ -z $newtodo ] || [ $newtodo = "?" ] &&  exit
	tasklist=$($EXECUTABLE -l -s | dmenu -l 3 -p "Select Tasklist" | grep -o '^[0-9]\+')
	[ -z $tasklist ] &&  tasklist=0
	date=$(echo "?" | dmenu -p "Enter date MM/DD/YYYY:")
	if [ -z $date ] || [ $date = "?" ]; then
		$EXECUTABLE -a  --title "$newtodo" --tasklist $tasklist
	else
		$EXECUTABLE -a  --title "$newtodo" -d "$date" --tasklist $tasklist
	fi;
	exit
}
# function: toggle 
# description: used to toggle a task between completed and incomplete
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
#create a new task
[ "$completed" = "New Todo" ] && createtodo
#clear all completed tasks
[ "$completed" = "clear" ] &&  $EXECUTABLE -c
#toggle a tasks
toggle $completed
