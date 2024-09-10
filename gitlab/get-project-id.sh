#!/usr/bin/bash

curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
	"https://$GITLAB_HOST/api/v4/projects" |
	jq -c '.[] | {id: .id, name_with_namespace: .name_with_namespace}' |
	fzf | jq '.id'
