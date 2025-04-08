#!/bin/bash

# Customize this path to your org files directory
ORG_DIR="$HOME/Documents/org"
DEBOUNCE_SECONDS=10
LAST_RUN=0

cd "$ORG_DIR" || {
	echo "Directory not found: $ORG_DIR"
	exit 1
}

# Add all changes
git add .

# Use a timestamp as the commit message
COMMIT_MSG="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

inotifywait -m -r -e close_write,create,delete,move "$ORG_DIR" --exclude ".git/**" |
	while read -r directory events filename; do
		# Only commit if there are changes
		NOW=$(date +%s)
		git add .
		sleep 1
		if ((NOW - LAST_RUN >= DEBOUNCE_SECONDS)) && ! git diff --cached --quiet; then
			git commit -m "$COMMIT_MSG"
			git pull --rebase # in case of remote changes
			git push
			echo "Changes committed and pushed."
			LAST_RUN=$NOW
		else
			echo "No changes to commit."
		fi
	done
