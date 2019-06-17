#!/bin/sh
# a script for converting Chrome Passwords.csv to pass
# files that can, its still a work in progress
# currently it is functional enough to use
FILE="$HOME/Documents/Chrome Passwords.csv"
PREFORMAT=$(tail -n +2 "$FILE" | sed '/http/!d' | sed '/^,android/d'| \
    sed 's/,/\n/g' | sed '/^http/d' | sed 'n;N;s/^/user:/')

echo "$PREFORMAT" > /tmp/chromepasstemp0.txt
numlines=$(wc -l < "/tmp/chromepasstemp0.txt")
numrepeats=$(( "$numlines" / 3))
numrepeats=$(( "$numrepeats" - 1))
echo "$numlines"
for i in $(seq "$numrepeats")
do
    passname=$(awk 'NR==1' "/tmp/chromepasstemp0.txt")
    pass=$(awk 'NR==3' "/tmp/chromepasstemp0.txt")
    user=$(awk 'NR==2' "/tmp/chromepasstemp0.txt")
    printf "%s\n%s" "$pass" "$user" | pass add -m "$passname"
    echo "$user";
    awk 'NR!=1 && NR!=2 && NR!=3' "/tmp/chromepasstemp0.txt" > /tmp/chromepasstemp1.txt
    cat /tmp/chromepasstemp1.txt > /tmp/chromepasstemp0.txt
done
