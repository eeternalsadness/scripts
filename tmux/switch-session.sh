#!/usr/bin/env bash

current_session=$(tmux display-message -p "#S")
session_name=$(tmux ls -F "#S" | fzf --tmux --prompt "Select a session to switch to: ")

# switch to selected session if it's different from current session
if [[ -n "$session_name" ]] && [[ "$session_name" != "$current_session" ]]; then
  tmux switch -t "$session_name"
fi
