package util

import (
  "encoding/base64"
  "fmt"
)

type Jira struct {
  domain string
  email string
  apiToken string
}

func (jira *Jira) GetAuthToken() string {
  auth := fmt.Sprintf("%s:%s", jira.email, jira.apiToken)
  return base64.StdEncoding.EncodeToString([]byte(auth))
}
