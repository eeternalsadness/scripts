package util

import (
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
)

type Jira struct {
	Domain string
	Email  string
	Token  string
}

func (jira *Jira) getAuthToken() string {
	auth := fmt.Sprintf("%s:%s", jira.Email, jira.Token)
	return base64.StdEncoding.EncodeToString([]byte(auth))
}

func (jira *Jira) CallApi(path string, method string) ([]byte, error) {
	// TODO: add actual error handling
	client := &http.Client{}
	req, err := http.NewRequest(method, fmt.Sprintf("https://%s/%s", jira.Domain, path), nil)
	if err != nil {
		return nil, fmt.Errorf("failed to form a HTTP request: %w", err)
	}

	req.Header.Add("Authorization", fmt.Sprintf("Basic %s", jira.getAuthToken()))
	req.Header.Add("Accept", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to call the Jira API: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read the response from the Jira API: %w", err)
	}

	return body, nil
}
