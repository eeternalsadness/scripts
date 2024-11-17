#!/bin/bash

# Variables
DOTFILES_REPO="https://github.com/eeternalsadness/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup"

echo -e "Starting dotfiles setup..."

# Step 1: Clone the repository
if [ -d "$DOTFILES_DIR" ]; then
    echo -e "Dotfiles directory already exists. Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull
else
    echo -e "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Step 2: Create a backup directory
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "Creating backup directory at $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
fi

# Step 3: Symlink dotfiles
echo -e "Linking dotfiles..."
cd "$DOTFILES_DIR" || exit 1

for file in .*; do
    # Ignore special files
    if [[ "$file" == "." || "$file" == ".." || "$file" == ".git" || "$file" == ".gitignore" ]]; then
        continue
    fi

    target="$HOME/$file"

    # Backup existing files
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "Backing up $target to $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Create symlink
    echo -e "Creating symlink for $file"
    ln -sf "$DOTFILES_DIR/$file" "$target"
done

echo -e "Dotfiles setup complete!"
