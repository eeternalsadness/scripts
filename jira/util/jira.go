package util

import (
  "net/http"
  "fmt"
  "io"
)

func (jira *Jira) CallApi(path string, method string) []byte {
  // TODO: add actual error handling
  client := &http.Client{}
  req, err := http.NewRequest(method, fmt.Sprintf("https://%s/%s", jira.Domain, path), nil)
  if err != nil {
    fmt.Println(err)
    return nil
  }

  req.Header.Add("Authorization", fmt.Sprintf("Basic %s", jira.GetAuthToken()))
  req.Header.Add("Accept", "application/json")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return nil
  }
  defer resp.Body.Close()

  body, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return nil
  }
  return body
}
