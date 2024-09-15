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

    local project_ids="[]"

    while true; do
        result=$(list_projects $page $items_per_page | jq -r '[.[] | {id: .id, name_with_namespace: .name_with_namespace}]')

        if [ "$result" == "[]" ]; then
            break
        fi

        project_ids=$(jq -n --argjson a "$project_ids" --argjson b "$result" '$a + $b')
        ((page++))
    done

    echo "$project_ids"
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

get_all_dangling_branches_in_project() {
    local project_id=$1
    local branches=($2)
    local page=1
    local items_per_page=100

    local dangling_branches=()
    for branch in ${branches[@]}; do
        open_mr_for_branch=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
            "https://$GITLAB_HOST/api/v4/projects/${project_id}/merge_requests?scope=created_by_me&state=opened&source_branch=$branch")

        if [ "$open_mr_for_branch" == "[]" ]; then
            dangling_branches+=("$branch")
        fi
    done

    echo ${dangling_branches[*]}
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

#url_encode() {
#    local string="$1"
#    python3 -c "import urllib.parse; print(urllib.parse.quote('$string'))"
#}

projects=$(get_all_project_ids)
user_email=$(get_user_email)

echo "$projects" | jq -c '.[]' | while IFS= read -r project; do
    project_id=$(echo "$project" | jq -r '.id')
    project_name=$(echo "$project" | jq -r '.name_with_namespace')

    branches=($(get_all_user_branches_in_project $project_id $user_email))
    dangling_branches=($(get_all_dangling_branches_in_project $project_id ${branches[*]}))

    for dangling_branch in ${dangling_branches[@]}; do

    done
done
