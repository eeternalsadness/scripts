#!/usr/bin/bash

list_projects() {
    local page=$1
    local items_per_page=$2
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/projects?membership=true&page=$page&per_page=$items_per_page"
}

get_all_project_ids() {
    local page=1
    local items_per_page=100

    local project_ids=()
    while true; do
        result=($(list_projects $page $items_per_page | jq -r '.[].id'))

        if [ "${#result}" -eq 0 ]; then
            break
        fi

        project_ids+=("${result[@]}")
        ((page++))
    done

    echo "${project_ids[*]}"
}

list_branches() {
    local project_id=$1
    local page=$2
    local items_per_page=$3
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/projects/${project_id}/repository/branches?page=$page&per_page=$items_per_page"
}

get_all_user_branches_in_project() {
    local project_id=$1
    local email=$2
    local page=1
    local items_per_page=100

    local branches=()
    while true; do
        result=($(list_branches $project_id $page $items_per_page | jq -r --arg email "$email" '.[] | select(.commit.author_email == $email and .default == false) | .name'))

        if [ "${#result}" -eq 0 ]; then
            break
        fi

        branches+=("${result[@]}")
        ((page++))
    done

    echo "${branches[*]}"
}

get_open_mrs() {
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/merge_requests?state=opened" | jq -r '.[] | select(.target_branch == "master")}'
}

get_user_email() {
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/user" | jq -r '.email'
}

get_user_id() {
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/user" | jq -r '.id'
}

project_ids=($(get_all_project_ids))
user_email=$(get_user_email)
#echo "${project_ids[@]}"

for project_id in ${project_ids[@]}; do
    echo "$project_id"
    branches=($(get_all_user_branches_in_project $project_id $user_email))
    echo "${branches[@]}"
done
