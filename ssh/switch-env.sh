#!/usr/bin/env bash

echo "=============================================================================="
echo "Script: $(basename $0)"
echo "Change the current ~/.ssh/config file to an SSH config file stored in the directory declared in the SSH_CONFIG_DIR environment variable."
echo "Requirements"
echo "- SSH_CONFIG_DIR is declared"
echo "- a valid config file exists in SSH_CONFIG_DIR"
echo "=============================================================================="

ssh_dir="$SSH_CONFIG_DIR"
config_file="$1"

if [[ -z "$config_file" ]]; then
  echo "Please specify the name of the config file to use!"
  echo "USAGE: sshenv [env_name]"
  exit 1
fi

config_file_path="$ssh_dir/$config_file"
if [[ ! -f "$config_file_path" ]]; then
  echo "Config file '$config_file' doesn't exist in '$config_file_path'!"
  exit 1
fi

# NOTE: symlink config file to ~/.ssh/config
ln -sf "$config_file_path" "$HOME/.ssh/config"

echo -e "\nSwitched to '$config_file'"
