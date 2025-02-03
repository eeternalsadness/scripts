package util

import (
	"encoding/json"
	"fmt"
	"net/url"
)

type Issue struct {
	Id     string
	Key    string
	Title  string
	Status string
	Url    string
}

func (jira *Jira) GetAssignedIssues() ([]Issue, error) {
	// call api
	jql := url.QueryEscape("assignee = currentuser() AND status NOT IN (Done, Rejected, Cancelled)")
	fields := url.QueryEscape("summary,status")
	path := fmt.Sprintf("rest/api/3/search/jql?jql=%s&fields=%s", jql, fields)
	resp, err := jira.CallApi(path, "GET")
	if err != nil {
		return nil, fmt.Errorf("failed to call Jira API: %w", err)
	}

	// parse json data
	var data map[string]interface{}
	json.Unmarshal(resp, &data)

	// transform json into output
	issues := data["issues"].([]interface{})
	outIssues := make([]Issue, len(issues))
	for i, issue := range issues {
		issueMap := issue.(map[string]interface{})
		fieldsMap := issueMap["fields"].(map[string]interface{})
		statusMap := fieldsMap["status"].(map[string]interface{})
		statusCategoryMap := statusMap["statusCategory"].(map[string]interface{})

		// get the necessary fields for the struct
		id := issueMap["id"].(string)
		key := issueMap["key"].(string)
		title := fieldsMap["summary"].(string)
		status := statusCategoryMap["name"].(string)
		url := issueMap["self"].(string)
		outIssues[i] = Issue{
			Id:     id,
			Key:    key,
			Title:  title,
			Status: status,
			Url:    url,
		}
	}

	return outIssues, nil
}
