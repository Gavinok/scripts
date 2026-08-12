#!/bin/env sh

rclone sync -P ~/.local/Dropbox drive:Dropbox
echo 'Backup Completed'
notify-send 'Backup Completed'
