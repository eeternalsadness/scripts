read -p "Enter the project name to search for: " search_term
echo $(curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://$GITLAB_HOST/api/v4/projects?search=$search_term")
