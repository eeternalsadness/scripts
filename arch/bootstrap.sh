#!/usr/bin/env bash

echo "Bootstrapping Arch Linux"

##############################################
# Install packages
##############################################

# prerequisites for devbox init script
sudo pacman -S --needed git curl xz

# hyprland requirements
sudo pacman -S --needed uwsm wofi dolphin waybar fnott xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprlock

# audio
sudo pacman -S --needed pipewire wireplumber

# bluetooth
sudo pacman -S --needed bluez bluez-utils

# power management
sudo pacman -S --needed cpupower brightnessctl

# screenshot
sudo pacman -S --needed grim slurp

# clipboard management
sudo pacman -S --needed wl-clipboard

# qutebrowser
sudo pacman -S --needed qutebrowser

# misc
sudo pacman -S --needed wikiman wget

##############################################
# Next steps
##############################################

echo "Next steps:"
echo "- Install & configure asusctl"
echo "- Install steam"
