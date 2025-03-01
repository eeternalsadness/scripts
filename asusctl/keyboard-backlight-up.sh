#!/usr/bin/env bash

current_brightness=$(asusctl -k | grep -E 'Current keyboard led brightness: ' | sed 's/Current keyboard led brightness: //')

if [[ "$current_brightness" != "High" ]]; then
  asusctl -n
fi
