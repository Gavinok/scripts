#!/bin/sh
# Depends on https://github.com/msherry/ical2org

ICAL2ORG_CMD="awk -f ~/.scripts/ical2org.awk"
# ICAL2ORG_CMD="ical2org -"

ERRORFILE=$(mktemp XXX.txt)
trap 'rm $ERRORFILE' EXIT TERM HUP

# Google Calendar
curl -s $(pass gcalics) 2>>$ERRORFILE | awk -f ~/.scripts/ical2org.awk > /home/gavinok/Documents/org/gcal.org 2>>$ERRORFILE
# School Dates
curl -s https://calendar.google.com/calendar/embed?src=fodf3o1k201nh0hi7oupnoijao7ousgc%40import.calendar.google.com&ctz=America%2FDawson_Creek 2>>$ERRORFILE | awk -f ~/.scripts/ical2org.awk > /home/gavinok/Documents/org/gcalSchool.org 2>>$ERRORFILE
# Holidays
curl -s https://calendar.google.com/calendar/embed?src=en.canadian%23holiday%40group.v.calendar.google.com&ctz=America%2FDawson_Creek 2>>$ERRORFILE | awk -f ~/.scripts/ical2org.awk > /home/gavinok/Documents/org/holidays.org 2>>$ERRORFILE

ERRORS=$(cat $ERRORFILE)

if [ -z $ERRORS ]
then notify-send "Google Calendar Has Been Added To Notes"
else notify-send "$ERRORS"
fi
