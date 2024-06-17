#!/usr/bin/bash

curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
	"https://$GITLAB_HOST/api/v4/users?per_page=100" |
	jq -c '.[] | {id: .id, name: .name, username: .username}' |
	fzf | jq '.id'
