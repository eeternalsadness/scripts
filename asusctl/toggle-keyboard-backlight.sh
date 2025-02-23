#!/usr/bin/env bash

kb_backlight_file="$HOME/.asus_kb_backlight"

if [[ ! -f "$kb_backlight_file" ]]; then
  touch "$kb_backlight_file"
fi

if [[ $(cat "$kb_backlight_file") -eq 1 ]]; then
  asusctl -k off
  echo "0" >"$kb_backlight_file"
else
  asusctl -k low
  echo "1" >"$kb_backlight_file"
fi
