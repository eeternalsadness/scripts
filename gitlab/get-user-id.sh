#!/usr/bin/env bash

page=1
per_page=100

read -rp "Enter the search term: " search_term

list_users() {
    curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "https://${GITLAB_HOST}/api/v4/users?search=$search_term&without_project_bots=true&page=$page&per_page=$per_page"
}

select_user() {
    list_users | jq -c '.[] | {id: .id, name: .name, username: .username}' |
        fzf | jq '.id'
}

users=$(list_users)

while true; do
    # check if there's no more search results
    if [[ -z "$users" || $(echo "$users" | jq 'length') -eq 0 ]]; then
        echo "Reached the end of search results. Exiting..."
        exit 0
    fi

    user_id=$(select_user)

    # selected user
    if [[ -n $user_id ]]; then
        # copy to clipboard
		echo -n "$user_id" | xclip -selection clipboard
        echo "$user_id"
        exit 0
    fi

    read -rp "Press Enter to continue searching, or press 'q' to quit: " input
    if [[ "$input" == "q" ]]; then
        echo "Exiting..."
        exit 0
    fi

    ((page++))
    users=$(list_users)
done
