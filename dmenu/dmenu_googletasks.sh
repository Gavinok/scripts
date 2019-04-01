#!/usr/bin/sh
# a simple todo script that integrates with calcurse
EXECUTABLE='python2.7 /home/gavinok/tasky.py'
PROMPT='to do:'
createtodo(){
	newtodo=$(echo "?" | dmenu -p "Enter the new TODO item:")
	[ -z $newtodo ] &&  exit
	date=$(echo "?" | dmenu -p "enter date MM/DD/YYYY:")
	if [ -z $date ] || [ $date = "?" ]; then
		$EXECUTABLE -a --title "$newtodo"
	else
		$EXECUTABLE -a -t "$newtodo" -d "$date"
	fi;
	#use edit to change anything else
	exit
}
# indexparser(){
#  sed 's@^[^0-9]*\([0-9]\+\).*@\1@'
# }
# toggle(){
# }
# remove(){
# }
# edit(){
# }
mkdir "/tmp/dmenu_todo/"
touch "/tmp/dmenu_todo/tmp.txt"
echo "New Todo" > /tmp/dmenu_todo/tmp.txt
$EXECUTABLE -l | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tail -n +2 >> /tmp/dmenu_todo/tmp.txt
# python2.7 ~/tasky.py -l | sed 's/[\x01-\x1F\x7F]//g' >> /tmp/dmenu_todo/tmp.txt
completed=$(cat /tmp/dmenu_todo/tmp.txt | dmenu -l 10 -p "$PROMPT" |  sed 's/[0-9]. //g')
[ -z "$completed" ] &&  exit
if [ "$completed" = "New Todo" ]; then
	createtodo
else 
	res=$(printf "toggle\\nremove\\nedit" | dmenu -i -p 'Power Menu:'  ) 
	case "$res" in
		toggle)
			toggle $completed;;
		remove)
			remove $completed;;
		edit)
			edit $completed;;
	esac
fi;
# sed -i '/'"$completed"'/d' ~/.calcurse/todo

