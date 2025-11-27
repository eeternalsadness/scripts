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
  --user "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  "https://${JIRA_URL}/rest/api/3/${api_path}"
