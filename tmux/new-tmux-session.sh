#!/usr/bin/env bash

source $SCRIPTS/tmux/common.sh

if [[ -z "$TMUX" ]]; then
  echo "Must be in a tmux session! Use 'tinit' to start a new tmux session."
  exit 1
fi

session_name=$(new-workspace)

# switch to session
if [[ -n "$session_name" ]]; then
  echo "Switching to session '$session_name'"
  tmux switch -t "$session_name"
fi
