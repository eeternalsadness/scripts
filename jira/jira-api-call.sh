#!/usr/bin/env bash

header="Accept: application/json"
method="$1"
api_path="$2"

url="https://${JIRA_DOMAIN}/rest/api/3/${api_path}"
echo "$url"

curl -fsSL --request "$method" \
  --url "$url" \
  --user "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  --header "$header" |
  jq
