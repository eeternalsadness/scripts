#!/bin/bash

if [[ $# -eq 1 ]]; then
  method="GET"
  api_path="$1"
elif [[ $# -eq 2 ]]; then
  method="$1"
  api_path="$2"
else
  echo "Must have 1 or 2 arguments!"
  exit 1
fi

curl -s --request "$method" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer ${JIRA_ADMIN_API_TOKEN}" \
  "https://api.atlassian.com/admin/${api_path}"
