#!/usr/bin/env bash

kb_backlight_file="$HOME/.asus_kb_backlight"

if [[ ! -f "$kb_backlight_file" ]]; then
  touch "$kb_backlight_file"
fi

# handle custom brightness
if [[ -n "$1" ]]; then
  if [[ ! "$1" =~ ^(off|low|med|high)$ ]]; then
    echo "Invalid keyboard brightness '$1'!"
    exit 1
  fi

  asusctl -k "$1"
  echo "$1" >"$kb_backlight_file"
else
  if [[ $(cat "$kb_backlight_file") != "off" ]]; then
    asusctl -k off
    echo "off" >"$kb_backlight_file"
  else
    # use low as default
    asusctl -k low
    echo "low" >"$kb_backlight_file"
  fi
fi
