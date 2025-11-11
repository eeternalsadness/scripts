#!/bin/bash

email_to_search=$1

response=$(aws sesv2 list-suppressed-destinations)
result=$(jq -r '.SuppressedDestinationSummaries[] | select (.EmailAddress == "'"$email_to_search"'")' <<<"$response")
next_token=$(jq -r '.NextToken' <<<"$response")

while [[ "$next_token" != "null" ]]; do
  if [[ -n "$result" ]]; then
    break
  fi

  response=$(aws sesv2 list-suppressed-destinations --next-token "$next_token")
  result=$(jq -r '.SuppressedDestinationSummaries[] | select (.EmailAddress == "'"$email_to_search"'")' <<<"$response")
  next_token=$(jq -r '.NextToken' <<<"$response")
done

echo "$result"
