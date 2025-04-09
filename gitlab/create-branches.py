#!/usr/bin/env python3

import requests
import os
import time
from queue import Queue

# WARN: make sure to set the following envs
GITLAB_TOKEN = os.getenv("GITLAB_TOKEN")
GITLAB_HOST = os.getenv("GITLAB_HOST")

HEADERS = {"PRIVATE-TOKEN": GITLAB_TOKEN}

project_queue = Queue()
execution_dict = {}

# NOTE: change the following inputs as necessary
# max 3 concurrent pipelines
MAX_CONCURRENT_PIPELINES = 3

project_ids = {
    # "audit_trail": 411,
    # "cpanel": 1210,
    # "identity": 1479,
    # "mobile": 1508,
    "ordering": 1511,
    # "digital_marketing": 1352,
    # "miniapp_api": 1502,
    # "report": 1510,
    # "mhql": 1620,
    # "sync_gateway": 1354,
    # "partner": 458,
    # "promotion": 495,
    # "webhook": 67,
    # "webhook_service": 110,
    # "tracking": 543,
    # "tracking_v4": 1544,
    # "import_export": 1509,
    # "import_export_v2": 1548,
    # "sms": 1013,
    # "sms_v2": 1630,
    # "notification": 786,
    # "einvoice": 957,
    # "background_jobs": 989,
    # "web_pos": 143,
    # "web_recap": 1252,
    # "eventstore_db": 1019,
    # "identity_db": 1469,
    # "location_db": 1178,
    # "partner_db": 1020,
    # "partner_mapping_db": 1593,
    # "promotion_db": 1351,
    # "sharding_db": 1513,
    # "sync_gateway_db": 1363,
}
num_projects = len(project_ids.keys())

team_names = [
    # "wakanda",
    # "phoenix",
    # "team2",
    # "inpay",
    "hydra",
]


def call_gitlab_api(method, headers, path):
    url = f"https://{GITLAB_HOST}/api/v4/{path}"
    match method.lower():
        case "get":
            response = requests.get(url, headers=headers)
        case "post":
            response = requests.post(url, headers=headers)
        case _:
            raise Exception(f"Invalid method '{method}'!")

    return {
        "status_code": response.status_code,
        "body": response.json(),
    }


def populate_project_queue():
    for project in project_ids:
        for team_name in team_names:
            project_queue.put(
                {
                    "team": team_name,
                    "project_name": project,
                    "project_id": project_ids[project],
                }
            )


def create_branch(project_id, team_name):
    response = call_gitlab_api(
        "POST",
        HEADERS,
        f"projects/{project_id}/repository/branches?branch=development-{team_name}&ref=development",
    )
    return response


def create_pipeline(project_id, team_name):
    response = call_gitlab_api(
        "POST",
        HEADERS,
        f"projects/{project_id}/pipeline?ref=development-{team_name}",
    )
    return response


def print_current_status(status_dict):
    for team_name in team_names:
        pipelines_ran = (
            status_dict[team_name]["success"]
            + status_dict[team_name]["skipped"]
            + status_dict[team_name]["canceled"]
            + status_dict[team_name]["failed"]
        )
        print(f"""
Team {team_name}:
    success: {status_dict[team_name]["success"]}
    skipped: {status_dict[team_name]["skipped"]}
    canceled: {status_dict[team_name]["canceled"]}
    failed: {status_dict[team_name]["failed"]}
    total: {pipelines_ran}/{num_projects}""")


def print_final_status(status_dict):
    print("""
===========================================

Result:""")
    for team_name in team_names:
        print(f"""
Team {team_name}:
    Success pipelines: {status_dict[team_name]["success"]}/{num_projects}""")
        if status_dict[team_name]["skipped_pipelines"]:
            print("    Skipped pipelines:")
            for skipped_pipeline in status_dict[team_name]["skipped_pipelines"]:
                print(f"        {skipped_pipeline}")
        if status_dict[team_name]["canceled_pipelines"]:
            print("    Canceled pipelines:")
            for skipped_pipeline in status_dict[team_name]["canceled_pipelines"]:
                print(f"        {skipped_pipeline}")
        if status_dict[team_name]["failed_pipelines"]:
            print("    Failed pipelines:")
            for failed_pipeline in status_dict[team_name]["failed_pipelines"]:
                print(f"        {failed_pipeline}")


def execute():
    # NOTE: store status of all pipelines for all teams
    status_dict = {}
    for team_name in team_names:
        status_dict[team_name] = {
            "success": 0,
            "skipped": 0,
            "canceled": 0,
            "failed": 0,
            "skipped_pipelines": [],
            "canceled_pipelines": [],
            "failed_pipelines": [],
        }

    try:
        start_time = time.time()
        while execution_dict or not project_queue.empty():
            # NOTE: populate execution dict
            while (
                len(execution_dict.keys()) < MAX_CONCURRENT_PIPELINES
                and not project_queue.empty()
            ):
                project = project_queue.get()
                # print(
                #    f"Creating branch for team '{project['team']}' in '{project['project_name']}'"
                # )
                # create_branch(project["project_id"], project["team"])
                print(
                    f"Creating pipeline for branch 'development-{project['team']}' in '{project['project_name']}'"
                )
                create_pipeline_response = create_pipeline(
                    project["project_id"], project["team"]
                )
                project["pipeline_id"] = create_pipeline_response["body"]["id"]
                execution_dict[f"{project['team']}/{project['project_name']}"] = project

            # NOTE: wait for pipelines to run, otherwise calling the API might result in an error
            print("Waiting for pipelines to run...")
            time.sleep(30)

            print(f"""
===========================================

Status:

Elapsed time: {round(time.time() - start_time)} s

Current pipelines:""")

            # NOTE: process pipelines that are currently in execution
            execution_done = []
            for execution in execution_dict:
                project = execution_dict[execution]
                response = call_gitlab_api(
                    "GET",
                    HEADERS,
                    # f"projects/{project['project_id']}/pipelines/latest?ref=development-{project['team']}",
                    f"projects/{project['project_id']}/pipelines/{project['pipeline_id']}",
                )

                # NOTE: update overall status based on the current pipelines status
                match response["body"]["status"]:
                    case "success":
                        status_dict[project["team"]]["success"] += 1
                        execution_done.append(execution)
                    case "skipped":
                        status_dict[project["team"]]["skipped"] += 1
                        status_dict[project["team"]]["skipped_pipelines"].append(
                            project["project_name"]
                        )
                        execution_done.append(execution)
                    case "canceled":
                        status_dict[project["team"]]["canceled"] += 1
                        status_dict[project["team"]]["canceled_pipelines"].append(
                            project["project_name"]
                        )
                        execution_done.append(execution)
                    case "failed":
                        status_dict[project["team"]]["failed"] += 1
                        status_dict[project["team"]]["failed_pipelines"].append(
                            project["project_name"]
                        )
                        execution_done.append(execution)
                print(f"    {execution}: {response['body']['status']}")
            print_current_status(status_dict)

            # NOTE: remove pipelines that are done from execution "list"
            for execution in execution_done:
                del execution_dict[execution]

    finally:
        print_final_status(status_dict)


def main():
    populate_project_queue()
    execute()


if __name__ == "__main__":
    main()
