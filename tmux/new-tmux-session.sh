#!/bin/bash

set -eou pipefail

source "$SCRIPTS/tmux/common.sh"

if [[ -z "$TMUX" ]]; then
  echo "Must be in a tmux session! Use 'ti' to start a new tmux session."
  exit 1
fi

session_name=$(new-workspace)

# switch to session
if [[ -n "$session_name" ]]; then
  tmux switch -t "$session_name"
fi
