#!/bin/bash

get_devbox_env() {
  local devbox_repo_dir="${1:-$HOME/Repo/personal/devbox}"
  local prompt_msg="Select the devbox project to use: "
  local devbox_envs=()
  local devbox_env=""

  if type fzf >/dev/null 2>&1; then
    devbox_env=$(fzf --walker=dir --walker-root="$devbox_repo_dir" --prompt="$prompt_msg")
  else
    for dir in $devbox_repo_dir/*/; do
      devbox_envs+=("$dir")
    done

    PS3="$prompt_msg"
    select env in "${devbox_envs[@]}"; do
      devbox_env="$env"
      break
    done
  fi

  echo "$devbox_env"
}
