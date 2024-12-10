#!/usr/bin/env bash

# main session
if [[ -z $(tmux has-session -t main) ]]; then
  tmux new-session -d -s main
  tmux rename-window -t main:1 "repo"
  tmux send-keys -t main:1 "cd $REPO" C-m
  tmux send-keys -t main:1 "nvim ." C-m
  tmux new-window -t main:2 -n "bash"
  tmux new-window -t main:3 -n "obsidian"
  tmux send-keys -t main:3 "cd $OBSIDIAN" C-m
  tmux send-keys -t main:3 "nvim ." C-m
fi

# ssh session
if [[ -z $(tmux has-session -t ssh) ]]; then
  tmux new-session -d -s ssh
fi

# attach to main & show first window
tmux select-window -t main:1
tmux attach-session -t main
