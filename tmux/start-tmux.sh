#!/usr/bin/env bash

source $SCRIPTS/tmux/common.sh

if [[ -n "$TMUX" ]]; then
  echo "tmux already running!"
  exit 1
fi

# create ssh session if there isn't any
if [[ -z $(tmux has-session -t ssh) ]]; then
  tmux new-session -d -s ssh
  tmux new-window -t "ssh:1" -n "obsidian" -c "$OBSIDIAN"
  tmux send-keys -t "ssh:1" "nvim ." C-m
  tmux new-window -t "ssh:2"
fi

# check if there's already a workspace session
current_workspaces=$(tmux ls -F "#S" | grep "Repo")
if [[ -z "$current_workspaces" ]]; then
  # create a new workspace if there's no workspace session
  session_name=$(new-workspace)
else
  # choose a workspace to attach to
  session_name=$(echo "$current_workspaces" | fzf --prompt "Select a workspace to attach to: ")
fi

# attach to session
tmux attach-session -t "$session_name"
