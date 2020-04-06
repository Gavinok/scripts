#!/bin/sh

clip() {
	echo "${1}"
	command -v xsel >/dev/null && echo "${1}" | xsel -i
	command -v xclip >/dev/null && echo "${1}" | xclip -i
}

# The channel ID prefix URL for RSS:
channelprefix='https://www.youtube.com/feeds/videos.xml?channel_id='
# The username prefix URL for RSS:
userprefix='https://www.youtube.com/feeds/videos.xml?user='
# The playlist prefix URL for RSS:
playlistprefix='https://www.youtube.com/feeds/videos.xml?playlist_id='
if [ $(echo "$*" | grep 'https://www.youtube.com/user/') ];then
	user=$(echo "$*" | cut -d/ -f5)
	rssfeed="$userprefix$user"
	clip "${rssfeed}"
fi
if [ $(echo "$*" | grep 'https://www.youtube.com/channel/') ];then
	id=$(echo "${*}" | cut -d/ -f5)
	rssfeed="$channelprefix$id"
	clip "${rssfeed}"
fi
if [ $(echo "${*}" | grep 'https://www.youtube.com/watch') ];then
	id=$(echo "${*}" | cut -d= -f3)
	rssfeed="$playlistprefix$id"
	clip "${rssfeed}"
fi
# https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA
# https://www.youtube.com/user/ChrisWereDigital
# https://www.youtube.com/watch?v=UWpf4ZSAHBo&list=PL-p5XmQHB_JRlxgcaj-WxkAylXFuE0gyk
# curl "$*" 
