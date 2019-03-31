#!/usr/bin/sh
# a simple todo script that integrates with calcurse
PROMPT='to do:'
createtodo(){
	newtodo=$(echo "?" | dmenu -p "Enter the new TODO item:")
	[ -z $newtodo ] &&  exit
	priority=$(echo "0" | dmenu -p "Enter the TODO priority [0 (none), 1 (highest) - 9 (lowest)]:")
  	if echo $priority | egrep -q '^[0-9]+$' ; then
		#is a number
		newtodo='['$priority'] '$newtodo
		echo $newtodo >> ~/.calcurse/todo
	else
		#not a number
		echo "Priority must be a number" | dmenu -p "Error"
	fi
	exit
}
mkdir "/tmp/dmenu_todo/"
touch "/tmp/dmenu_todo/tmp.txt"
echo "New Todo" > /tmp/dmenu_todo/tmp.txt
calcurse -t | sed 's/^0. /    /g' | tail -n +2 >> /tmp/dmenu_todo/tmp.txt
completed=$(cat /tmp/dmenu_todo/tmp.txt | dmenu -l 10 -p $PROMPT |  sed 's/[0-9]. //g')
[ -z "$completed" ] &&  exit
if [ "$completed" = "New Todo" ]; then
	createtodo
fi;
sed -i '/'"$completed"'/d' ~/.calcurse/todo

