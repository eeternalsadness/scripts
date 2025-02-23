#!/usr/bin/env bash

case "$1" in
"low")
  # NOTE: on battery, maximum power saving
  asusctl profile -P Quiet
  supergfxctl -m Integrated
  # TODO: add panel refresh rate & brightness update
  ;;
"med")
  # NOTE: on AC power, moderate performance with low fan noise
  asusctl profile -P Quiet
  supergfxctl -m Hybrid
  # TODO: add panel refresh rate & brightness update
  ;;
"high")
  # NOTE: on AC power, max performance with max fan noise
  asusctl profile -P Balanced
  supergfxctl -m Hybrid
  # TODO: add panel refresh rate & brightness update
  ;;
*)
  echo "Invalid power profile '$1'!"
  echo "Valid profiles are: low, med, high"
  exit 1
  ;;
esac
