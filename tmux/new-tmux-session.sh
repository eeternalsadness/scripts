#!/usr/bin/env bash

source $SCRIPTS/tmux/common.sh

if [[ -z "$TMUX" ]]; then
  echo "Must be in a tmux session! Use 'ti' to start a new tmux session."
  exit 1
fi

session_name=$(new-workspace)

# switch to session
if [[ -n "$session_name" ]]; then
  echo "Switching to session '$session_name'" >&2
  tmux switch -t "$session_name"
fi
