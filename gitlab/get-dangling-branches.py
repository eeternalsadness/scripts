#!/usr/bin/env python3

import requests
import os

# Set your GitLab token and host
GITLAB_TOKEN = os.getenv("GITLAB_TOKEN")
GITLAB_HOST = os.getenv("GITLAB_HOST")

HEADERS = {"PRIVATE-TOKEN": GITLAB_TOKEN}


def call_gitlab_api(method, headers, path):
    url = f"https://{GITLAB_HOST}/api/v4/{path}"
    match method.lower():
        case "get":
            response = requests.get(url, headers=headers)
        case "post":
            response = requests.post(url, headers=headers)
        case "delete":
            response = requests.delete(url, headers=headers)
        case _:
            raise Exception(f"Invalid method '{method}'!")

    return {
        "status_code": response.status_code,
        "body": response.json(),
    }


# List projects with pagination
def list_projects(page, items_per_page):
    path = f"projects?membership=true&simple=true&page={page}&per_page={items_per_page}"
    return call_gitlab_api("GET", HEADERS, path)


# Get all project IDs
def get_all_project_ids():
    page = 1
    items_per_page = 100
    project_ids = []

    while True:
        result = list_projects(page, items_per_page)
        if not result["body"]:
            break

        project_ids.extend(
            [
                {"id": proj["id"], "name_with_namespace": proj["name_with_namespace"]}
                for proj in result["body"]
            ]
        )
        page += 1

    return project_ids


# Get recent project IDs by pushed events
def get_recent_project_ids():
    path = "events?action=pushed&per_page=100"
    response = call_gitlab_api("GET", HEADERS, path)
    project_ids = [event["project_id"] for event in response["body"]]
    return sorted(set(project_ids))


# List recent branches in a project
def list_recent_branches(project_id, items_per_page):
    path = f"projects/{project_id}/repository/branches?sort=updated_desc&page=1&per_page={items_per_page}"
    response = call_gitlab_api("GET", HEADERS, path)
    return response["body"]


# Get all user branches in a project
def get_all_user_branches_in_project(project_id, email):
    branches_on_page = list_recent_branches(project_id, 20)
    branches = [
        branch["name"]
        for branch in branches_on_page
        if branch["commit"]["author_email"] == email and not branch["default"]
    ]
    return branches


# Get all dangling branches in a project
def get_all_dangling_branches_in_project(project_id, branches):
    dangling_branches = []
    for branch in branches:
        path = f"projects/{project_id}/merge_requests?scope=created_by_me&state=opened&source_branch={branch}"
        response = call_gitlab_api("GET", HEADERS, path)
        if not response["body"]:
            dangling_branches.append(branch)
    return dangling_branches


# Get open merge requests targeting master/main
def get_open_mrs():
    path = "merge_requests?state=opened"
    response = call_gitlab_api("GET", HEADERS, path)
    return [
        mr
        for mr in response["body"]
        if mr["target_branch"] == "master" or mr["target_branch"] == "main"
    ]


# Get the user's email
def get_user_email():
    response = call_gitlab_api("GET", HEADERS, "user")
    return response["body"]["email"]


# Delete a branch
# def delete_branch(project_id, branch_name):
#    url = f"https://{GITLAB_HOST}/api/v4/projects/{project_id}/repository/branches/{urllib.parse.quote(branch_name)}"
#    response = requests.delete(url, headers=HEADERS)
#    return response.status_code


# Main logic to find dangling branches without open MRs
def main():
    user_email = get_user_email()
    print(f"Getting all projects that '{user_email}' is a member of...")

    projects = get_all_project_ids()
    all_dangling_branches = []

    for project in projects:
        project_id = project["id"]
        project_name = project["name_with_namespace"]

        # print(f"Getting all branches created by '{user_email}' in '{project_name}'")
        branches = get_all_user_branches_in_project(project_id, user_email)

        print(
            f"Getting all branches created by '{user_email}' without an open MR in '{project_name}'"
        )
        dangling_branches = get_all_dangling_branches_in_project(project_id, branches)

        for dangling_branch in dangling_branches:
            all_dangling_branches.append(f"{project_name},{dangling_branch}")

    print(f"Found {len(all_dangling_branches)} dangling branches:")
    for branch in all_dangling_branches:
        print(branch)


if __name__ == "__main__":
    main()
