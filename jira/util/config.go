package util

import (
  "encoding/base64"
  "fmt"
)

type Config struct {
  domain string
  email string
  apiToken string
}

func (config *Config) GetAuthToken() string {
  auth := fmt.Sprintf("%s:%s", config.email, config.apiToken)
  return base64.StdEncoding.EncodeToString([]byte(auth))
}
