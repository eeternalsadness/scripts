#!/usr/bin/env bash

echo "=============================================================================="
echo "Script: $(basename $0)"
echo "Fuzzy search Gitlab projects that you're a member of to get the project's ID, then copy the ID to clipboard"
echo "Assumptions"
echo "- exported GITLAB_TOKEN"
echo "- exported GITLAB_HOST"
echo "- installed fzf"
echo "=============================================================================="

page=1       # WARN: don't change this value!
per_page=100 # NOTE: this value can be anywhere between 1 & 100

read -rp "Enter the search term (leave blank to search all projects): " search_term

list_projects() {
  curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
    "https://${GITLAB_HOST}/api/v4/projects?membership=true&search=$search_term&page=$page&per_page=$per_page"
}

select_project() {
  list_projects | jq -c '.[] | {id: .id, name_with_namespace: .name_with_namespace}' |
    fzf | jq '.id'
}

projects=$(list_projects)

while true; do
  # check if there's no more search results
  if [[ -z "$projects" || $(echo "$projects" | jq 'length') -eq 0 ]]; then
    echo "Reached the end of search results. Exiting..."
    exit 0
  fi

  project_id=$(select_project)

  # selected project
  if [[ -n $project_id ]]; then
    # copy to clipboard
    if [[ $(uname) == "Darwin" ]]; then
      echo -n "$project_id" | pbcopy
    else
      echo -n "$project_id" | xclip -in selection clipboard
    fi
    echo "$project_id"
    exit 0
  fi

  read -rp "Press Enter to continue searching, or press 'q' to quit: " input
  if [[ "$input" == "q" ]]; then
    echo "Exiting..."
    exit 0
  fi

  ((page++))
  projects=$(list_projects)
done
