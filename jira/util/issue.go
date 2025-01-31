package util

type Issues struct {
  Issues []Issue `json:"issues"`
}

type Issue struct {
  Fields Fields `json:"fields"`
  Id string `json:"id"`
  Key string `json:"key"`
  Self string `json:"self"`
}
