#!/bin/bash

source "$SCRIPTS/devbox/common.sh"

if [[ -z "$DEVBOX_SHELL_ENABLED" ]]; then
  devbox_env=$(get_devbox_env)

  if [[ -z "$devbox_env" ]]; then
    echo "No selection made. Cannot start a devbox shell!"
  else
    devbox shell -c "$devbox_env"
  fi
elif [[ "$CALLER" == "dbs" ]]; then
  echo "Already in devbox shell!"
fi
