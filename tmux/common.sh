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

  tmux new-session -d -s "$session_name" -c "$git_repo"
  tmux rename-window -t "${session_name}:1" "repo"
  # NOTE: need to cd first so that fzf works correctly inside neovim
  tmux send-keys -t "${session_name}:1" "nvim ." C-m
  tmux new-window -t "${session_name}:2" -n "obsidian" -c "$OBSIDIAN"
  tmux send-keys -t "${session_name}:2" "nvim ." C-m
  tmux new-window -t "${session_name}:3" -n "shell" -c "$git_repo"
  tmux select-window -t "${session_name}:1"

  echo "$session_name"
}

select-git-repo() {
  repo_escaped=$(echo "$REPO" | sed 's/\//\\\//g')
  repo_dir=$(find -L "$REPO" -maxdepth 3 -type d -name ".git" | sed 's/\/\.git//' | sed "s/${repo_escaped}\///" | fzf --prompt "Select a git repo: ")

  echo "$repo_dir"
}

format-session-name() {
  # NOTE: format session name so that it doesn't contain any bad special characters
  # FIXME: ideally I should only do this on the actual repo name, not the parent directories as well
  session_name=$1
  echo "$session_name" | sed 's/[^a-zA-Z0-9\-\/]/-/g' | sed 's/--*/-/g'
}
