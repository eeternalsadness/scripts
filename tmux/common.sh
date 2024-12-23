#!/usr/bin/env bash

new-workspace() {
  git_repo=$(select-git-repo)

  # check if a git repo was selected
  if [[ -z "$git_repo" ]]; then
    echo "Invalid selection!" >&2
    exit 1
  fi

  session_name="Repo/$(format-session-name ${git_repo})"
  git_repo="${REPO}/${git_repo}"

  # check if session already exists
  if [[ -z $(tmux has -t "$session_name" 2>&1) ]]; then
    echo "Session '$session_name' already exists!" >&2
    echo "Switching to session '$session_name'" >&2
    tmux switch -t "$session_name"
    exit 0
  fi

  tmux new-session -d -s "$session_name"
  tmux rename-window -t "${session_name}:1" "repo"
  tmux send-keys -t "${session_name}:1" "cd ${git_repo}" C-m
  tmux send-keys -t "${session_name}:1" "nvim ." C-m
  tmux new-window -t "${session_name}:2" -n "bash"
  tmux send-keys -t "${session_name}:2" "cd ${git_repo}" C-m
  tmux new-window -t "${session_name}:3" -n "obsidian"
  tmux send-keys -t "${session_name}:3" "cd ${OBSIDIAN}" C-m
  tmux send-keys -t "${session_name}:3" "nvim ." C-m
  tmux select-window -t "${session_name}:1"

  echo "$session_name"
}

select-git-repo() {
  repo_escaped=$(echo "$REPO" | sed 's/\//\\\//g')
  repo_dir=$(find -L "$REPO" -type d -name ".git" -maxdepth 3 | sed 's/\/\.git//' | sed "s/${repo_escaped}\///" | fzf --prompt "Select a git repo: ")

  echo "$repo_dir"
}

format-session-name() {
  # NOTE: format session name so that it doesn't contain any bad special characters
  session_name=$1
  echo "$session_name" | sed 's/[^a-zA-Z0-9-]/-/g' | sed 's/--*/-/g'
}