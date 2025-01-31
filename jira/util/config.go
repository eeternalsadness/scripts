package util

import (
  "encoding/base64"
  "fmt"
)

// TODO: find a way to rename/refactor structs
type Jira struct {
  Domain string
  Email string
  Token string
}

func (jira *Jira) GetAuthToken() string {
  auth := fmt.Sprintf("%s:%s", jira.Email, jira.Token)
  return base64.StdEncoding.EncodeToString([]byte(auth))
}
