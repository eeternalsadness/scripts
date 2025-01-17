#!/usr/bin/env bash

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
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://${GITLAB_HOST}/api/v4/${api_path}" |
  jq
