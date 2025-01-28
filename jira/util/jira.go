package util

import (
  "net/http"
  "fmt"
  "io"
)

func (jira *Jira) CallApi(path string, method string) {
  client = &http.Client{}
  req, err := http.NewRequest(method, fmt.Sprintf("https://%s/%s", jira.domain, path), nil)
  req.Header.Add("Authorization", fmt.Sprintf("Basic %s", jira.GetAuthToken()))
  req.Header.Add("Accept", "application/json")

  resp, err := client.Do(req)
  defer resp.Body.Close()

  body, err := io.ReadAll(resp.Body)
  return body
}
