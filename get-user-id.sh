#!/usr/bin/bash

page=1
per_page=100

list_users() {
	curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
		"https://$GITLAB_HOST/api/v4/users?page=$page&per_page=$per_page"
}

select_user() {
	list_users | jq -c '.[] | {id: .id, name: .name, username: .username}' |
		fzf | jq '.id'
}

users=$(list_users)

while true; do
	# check if there's no more user to fetch
	if [[ -z $users || $(echo "$users" | jq 'length') -eq 0 ]]; then
		echo "Reached the end of list of users. Exiting..."
		exit 0
	fi

	user_id=$(select_user)

	# selected user
	if [[ -n $user_id ]]; then
		echo "$user_id"
		exit 0
	fi

	read -rp "Press Enter to go to next page, or press 'q' to quit: " input
	if [[ "$input" == "q" ]]; then
		echo "Exiting..."
		exit 0
	fi

	((page++))
	users=$(list_users)
done
