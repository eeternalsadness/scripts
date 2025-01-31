package util

type Status struct {
  StatusCategory StatusCategory `json:"statusCategory"`
}

type StatusCategory struct {
  Name string `json:"name"`
}
