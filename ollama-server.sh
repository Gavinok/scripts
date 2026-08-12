#!/bin/dash

if ! pgrep -x ollama; then
	export OLLAMA_MODELS=${HOME}/.local/share/ollama
	/usr/bin/ollama serve
else
	killall ollama
fi
