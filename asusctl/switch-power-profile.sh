#!/usr/bin/env bash

case "$1" in
"low")
  # NOTE: on battery, maximum power saving
  asusctl profile -P Quiet
  supergfxctl -m Integrated
  brightnessctl -c backlight s 20%
  # TODO: add panel refresh rate
  ;;
"med")
  # NOTE: on AC power, moderate performance with low fan noise
  asusctl profile -P Quiet
  supergfxctl -m Hybrid
  brightnessctl -c backlight s 50%
  # TODO: add panel refresh rate
  ;;
"high")
  # NOTE: on AC power, max performance with max fan noise
  asusctl profile -P Balanced
  supergfxctl -m Hybrid
  brightnessctl -c backlight s 50%
  # TODO: add panel refresh rate
  ;;
*)
  echo "Invalid power profile '$1'!"
  echo "Valid profiles are: low, med, high"
  exit 1
  ;;
esac
