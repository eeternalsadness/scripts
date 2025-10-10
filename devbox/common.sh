get_devbox_env() {
  local devbox_repo_dir="${1:-$DEVBOX_REPO_DIR}"
  local prompt_msg="Select the devbox project to use: "
  local devbox_envs=()
  local devbox_env=""

  for dir in $devbox_repo_dir/*/; do
    devbox_envs+=("$dir")
  done

  PS3="$prompt_msg"
  select env in "${devbox_envs[@]}"; do
    devbox_env="$env"
    break
  done

  echo "$devbox_env"
}
