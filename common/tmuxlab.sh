#!/bin/bash

# Thanks Mistral AI Le Chat

# Define the session name
SESSION_NAME="homelab"

# Check if the session already exists 
if tmux has-session -t $SESSION_NAME 2>/dev/null; then 
	echo "Session '$SESSION_NAME' already exists. Attaching to it..." 
	tmux attach-session -t $SESSION_NAME 
else
	# Create a new tmux session with the first window running lazydocker
	tmux new-session -d -s $SESSION_NAME -n "lazydocker" "lazydocker"
	# Create the second window and change to the homelab folder
	tmux new-window -t $SESSION_NAME:1 -n "homelab" -c ~/homelab
	# Create the third window with no specific requirements
	tmux new-window -t $SESSION_NAME:2
	# Attach to the tmux session
	tmux attach-session -t $SESSION_NAME
fi