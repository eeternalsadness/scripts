#!/usr/bin/env bash

hyprland_config_file="$HOME/.config/hypr/hyprland.conf"
supergfxd_config_file="/etc/supergfxd.conf"

case "$1" in
"low")
  # NOTE: on battery, maximum power saving
  asusctl profile -P Quiet
  supergfxctl -m Integrated
  sudo sed -i 's/"mode": ".*"/"mode": "Integrated"/' "$supergfxd_config_file"
  brightnessctl -c backlight s 20%
  sed -i 's/^monitor=.*/monitor=,2560x1600@60.00,auto,auto/' "$hyprland_config_file"
  ;;
"med")
  # NOTE: on AC power, moderate performance with low fan noise
  asusctl profile -P Quiet
  supergfxctl -m Hybrid
  sudo sed -i 's/"mode": ".*"/"mode": "Hybrid"/' "$supergfxd_config_file"
  brightnessctl -c backlight s 50%
  sed -i 's/^monitor=.*/monitor=,2560x1600@120.00,auto,auto/' "$hyprland_config_file"
  ;;
"high")
  # NOTE: on AC power, max performance with max fan noise
  asusctl profile -P Balanced
  supergfxctl -m Hybrid
  sudo sed -i 's/"mode": ".*"/"mode": "Hybrid"/' "$supergfxd_config_file"
  brightnessctl -c backlight s 50%
  sed -i 's/^monitor=.*/monitor=,2560x1600@120.00,auto,auto/' "$hyprland_config_file"
  ;;
*)
  echo "Invalid power profile '$1'!"
  echo "Valid profiles are: low, med, high"
  exit 1
  ;;
esac
