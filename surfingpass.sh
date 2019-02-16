#!/bin/bash
site= dmenu -p "what do you want"
cat "~/.surf/Passwords.csv" | grep $site


