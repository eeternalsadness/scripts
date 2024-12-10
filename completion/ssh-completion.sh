#!/usr/bin/env bash

_complete_ssh_hosts() {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local ssh_config_file="$HOME/.ssh/config"

  local comp_ssh_hosts=""
  if [[ -f "$ssh_config_file" ]]; then
    comp_ssh_hosts=$(
      #awk '{split($1,aliases,","); if (aliases[1] !~ /^\[/) print aliases[1]}' ~/.ssh/known_hosts
      awk '/^Host/ && $2 !~ /[*]/ {print $2}' $HOME/.ssh/config
    )
  fi

  COMPREPLY=($(compgen -W "${comp_ssh_hosts}" -- $cur))
  return 0
}

_complete_ssh_config_files() {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"

  local comp_ssh_config_files=""
  if [[ -n "$SSH_CONFIG_DIR" ]]; then
    comp_ssh_config_files=$(ls "$SSH_CONFIG_DIR")
  fi

  COMPREPLY=($(compgen -W "${comp_ssh_config_files}" -- $cur))
  return 0
}

complete -F _complete_ssh_hosts ssh
complete -F _complete_ssh_config_files sshenv
