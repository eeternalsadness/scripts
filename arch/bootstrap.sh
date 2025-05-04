#!/usr/bin/env bash

echo "Bootstrapping Arch Linux"

##############################################
# Install packages
##############################################

# essentials
sudo pacman -S --needed --noconfirm git curl wget xz kitty which

# hyprland
sudo pacman -S --needed --noconfirm uwsm wofi dolphin waybar fnott xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprlock hyprland
systemctl --user enable --now waybar.service

# audio
sudo pacman -S --needed --noconfirm pipewire wireplumber pipewire-pulseaudio

# bluetooth
sudo pacman -S --needed --noconfirm bluez bluez-utils
systemctl enable --now bluetooth.service

# power management
sudo pacman -S --needed --noconfirm cpupower brightnessctl
# allow non-root user to change brightness
usermod -aG video bach
cat 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' >/etc/udev/rules.d/backlight.rules

# screenshot
sudo pacman -S --needed --noconfirm grim slurp

# clipboard management
sudo pacman -S --needed --noconfirm wl-clipboard

# qutebrowser
sudo pacman -S --needed --noconfirm qutebrowser

# font
sudo pacman -S --needed --noconfirm otf-comicshanns-nerd

# network debugging
sudo pacman -S --needed --noconfirm traceroute tcpdump net-tools nmap

# yay
sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay/

# snap
sudo yay -S --needed --noconfirm snapd
sudo systemctl enable --now snapd.socket

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# zsh
brew install zsh-autosuggestions zsh-syntax-highlighting pure

##############################################
# Next steps
##############################################

echo "Next steps:"
echo "- Install & configure asusctl"
echo "- Install steam"
