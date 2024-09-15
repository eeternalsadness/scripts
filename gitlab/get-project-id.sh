#!/usr/bin/bash

page=1
per_page=100

list_projects() {
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/projects?membership=true&page=$page&per_page=$per_page"
}

select_project() {
    list_projects | jq -c '.[] | {id: .id, name_with_namespace: .name_with_namespace}' |
        fzf | jq '.id'
}

projects=$(list_projects)

while true; do
    # check if there's no more project to fetch
    if [[ -z $projects || $(echo "$projects" | jq 'length') -eq 0 ]]; then
        echo "Reached the end of list of projects. Exiting..."
        exit 0
    fi

    project_id=$(select_project)

    # selected project
    if [[ -n $project_id ]]; then
        echo "$project_id"
        # copy to clipboard
        if [ "$(uname)" == "Darwin" ]; then
            echo "$project_id" | pbcopy
        else
            echo "$project_id" | xclip -selection clipboard
        fi
        exit 0
    fi

    read -rp "Press Enter to go to next page, or press 'q' to quit: " input
    if [[ "$input" == "q" ]]; then
        echo "Exiting..."
        exit 0
    fi

    ((page++))
    projects=$(list_projects)
done
