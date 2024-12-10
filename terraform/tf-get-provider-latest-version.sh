#!/bin/bash

echo "=============================================================================="
echo "Script: $(basename $0)"
echo "Get the latest version of the selected Terraform provider."
echo "Requirements"
echo "- fzf installed"
echo "- provide a list of providers in the script"
echo "=============================================================================="

# modify this list with the providers that you use
# this can be found in the url after "providers/"
# e.g. hashicorp/aws for https://registry.terraform.io/providers/hashicorp/aws/
providers=("hashicorp/aws" "hashicorp/external" "petoju/mysql" "cyrilgdn/postgresql")

selected_provider=$(printf '%s\n' "${providers[@]}" | fzf --prompt "Select a provider: ")

if [ -z "$selected_provider" ]; then
  echo "No selection made."
  exit 0
fi

response=$(curl -s "https://registry.terraform.io/v1/providers/$selected_provider/versions")
errors=$(echo "$response" | jq -r '.errors')

if [ "$errors" != "null" ]; then
  echo "Invalid provider: '$selected_provider'! Please check that the provider name is correct."
  exit 1
fi

latest_ver=$(echo "$response" | jq -r '.versions[].version' | sort -V | tail -n 1)

if [[ $(uname) == "Darwin" ]]; then
  echo -n "$latest_ver" | pbcopy
else
  echo -n "$latest_ver" | xclip -in selection clipboard
fi

echo "$latest_ver"
