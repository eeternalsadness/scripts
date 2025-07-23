#!/bin/bash

# List of GitLab project IDs
PROJECT_IDS=(
  1727
  1729
  1730
  1731
  1732
  1733
  1771
  1772
  1789
  1790
  1849
)

for PROJECT_ID in "${PROJECT_IDS[@]}"; do
  echo "Fetching latest tag for project ID $PROJECT_ID..."

  PROJECT_API_URL="https://${GITLAB_HOST}/api/v4/projects/${PROJECT_ID}"
  PROJECT_NAME=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$PROJECT_API_URL" | jq -r '.path_with_namespace')

  API_URL="https://${GITLAB_HOST}/api/v4/projects/${PROJECT_ID}/repository/tags"

  #curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$API_URL" | jq

  TAG=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$API_URL" |
    jq -r '.[0].name')

  if [[ "$TAG" == "null" || -z "$TAG" ]]; then
    echo "❌ No tags found for project $PROJECT_NAME (ID $PROJECT_ID)"
  else
    echo "✅ Latest tag for project $PROJECT_NAME (ID $PROJECT_ID): $TAG"
  fi

  echo "---------------------------"
done
