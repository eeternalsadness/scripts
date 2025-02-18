#!/usr/bin/env bash

echo "=============================================================================="
echo "Script: $(basename $0)"
echo "Generate an SSH config file from a JSON export from Remote Desktop Manager. Optionally copy your public key (in ~/.ssh/id_rsa.pub) to all the hosts using the password provided."
echo "Requirements"
echo "- sshpass installed"
echo "- jq installed"
echo "=============================================================================="

read -rp "Please enter the name of the output file: " file_name
file_path="$SSH_CONFIG_DIR/$file_name"

read -rp "Generate ssh config file? [y/n]: " generate_config
if [[ "$generate_config" == "y" ]]; then
  read -rp "Please enter the path to the exported json file: " json_file
  if [[ -f "$file_path" ]]; then
    echo "File '$file_name' already exists at '$file_path'!"
    exit 1
  fi

  domain_name="citigo.io"
  hosts=$(jq '[ .Connections[] | select(.ConnectionType == 77) | { Name: .Name, Group: .Group } ]' "$json_file")

  echo "Generating ssh config file..."
  touch "$file_path"
  for ((i = 0; i < $(jq -r 'length' <<<"$hosts"); i++)); do
    host=$(jq --argjson i "$i" -r '.[$i].Name' <<<"$hosts")
    group=$(jq --argjson i "$i" -r '.[$i].Group' <<<"$hosts")
    hostname="${host}.${domain_name}"
    if [[ "$group" != "null" ]]; then
      host="${group}/${host}"
    fi
    cat >>"$file_path" <<EOT
Host ${host}
    HostName ${hostname}
    StrictHostKeyChecking no

EOT
  done
  echo "Config file generated at '$file_path'."
fi

read -rp "Do you want to automatically add the public key to the exported hosts? (Enter 'yes' to confirm): " auto_add_pub_key
if [[ "$auto_add_pub_key" == "yes" ]]; then
  read -rsp "Enter the SSH password: " ssh_password
  echo -e "\n"
  for host in $(cat "$file_path" | grep '^Host' | sed 's/^Host //'); do
    echo "Adding public key to '$host'"
    sshpass -p "$ssh_password" ssh-copy-id -o StrictHostKeyChecking=no "$host"
  done
fi
