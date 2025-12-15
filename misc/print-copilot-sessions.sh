#!/bin/bash

set -euo pipefail

for file in ~/.copilot/session-state/*; do
  echo "$file"
  head "$file" | jq 'select(.type == "user.message") | .data.content'
done
