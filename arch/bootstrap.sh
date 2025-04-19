#!/usr/bin/env bash

echo "Bootstrapping Arch Linux"

##############################################
# Install packages
##############################################

# essentials
sudo pacman -S --needed git curl wget xz traceroute

# hyprland requirements
sudo pacman -S --needed uwsm wofi dolphin waybar fnott xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprlock

# audio
sudo pacman -S --needed pipewire wireplumber

# bluetooth
sudo pacman -S --needed bluez bluez-utils
systemctl enable --now bluetooth.service

# power management
sudo pacman -S --needed cpupower brightnessctl
# allow non-root user to change brightness
usermod -aG video bach
cat 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' >/etc/udev/rules.d/backlight.rules

# screenshot
sudo pacman -S --needed grim slurp

# clipboard management
sudo pacman -S --needed wl-clipboard

# qutebrowser
sudo pacman -S --needed qutebrowser

##############################################
# Next steps
##############################################

echo "Next steps:"
echo "- Install & configure asusctl"
echo "- Install steam"
