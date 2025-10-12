#!/bin/bash

dotfiles_dir=${1:-$REPO/personal/dotfiles}
scripts_dir=${2:-$SCRIPTS}

source "$scripts_dir/common/echo.sh"

# show warning and prompt for confirmation
echo_warning "This script will symlink all dotfiles in $dotfiles_dir to the home directory ($HOME)."
echo_warning "All directories in $dotfiles_dir/.config/ will also be symlinked to $HOME/.config/."
echo_warning "All files and directories will be backed up (with versioning) by default."

# symlink dotfiles
read -rp "Link dotfiles? [y/n]: " user_input
link_dotfiles=false
case "$user_input" in
"y") link_dotfiles=true ;;
"n") ;;
*)
  echo_error "Invalid input: '$user_input'."
  return 1
  ;;
esac

if $link_dotfiles; then
  echo "Linking dotfiles..."

  for file in "$dotfiles_dir"/.*; do
    file_name=$(basename "$file")

    # Ignore folders & special files
    if [[ -d "$file" ]] || [[ "$file_name" == ".gitignore" ]]; then
      continue
    fi

    target="$HOME/$file_name"

    # create symlink with versioned backup
    set +e
    symlink_target=$(readlink "$target")
    set -e
    if [[ "$symlink_target" == "$file" ]]; then
      echo "Symlink '$target' -> '$symlink_target' already exists!"
    else
      echo "Creating symlink for '$file' at '$target'"
      VERSION_CONTROL=t ln -sbv "$file" "$target"
    fi
  done
fi

# symlink dirs in .config/
read -rp "Link $HOME/.config? [y/n]: " user_input
link_configs=false
case "$user_input" in
"y") link_configs=true ;;
"n") ;;
*)
  echo_error "Invalid input: '$user_input'."
  return 1
  ;;
esac

if $link_configs; then
  if [[ ! -d "$HOME/.config" ]]; then
    mkdir "$HOME/.config"
  fi

  for file in "$dotfiles_dir"/.config/*; do
    file_name=$(basename "$file")

    # ignore special files
    if [[ "$file_name" == ".git" || "$file_name" == ".gitignore" ]]; then
      continue
    fi

    target="$HOME/.config/$file_name"

    # create symlink
    set +e
    symlink_target=$(readlink "$target")
    set -e
    if [[ "$symlink_target" == "$file" ]]; then
      echo "Symlink '$target' -> '$symlink_target' already exists!"
    else
      # back up target dir if it exists
      if [[ -d "$target" ]]; then
        VERSION_CONTROL=t mv -bTv "$target" "${target}.backup"
      fi

      echo "Creating symlink for '$file' at '$target'"
      VERSION_CONTROL=t ln -sbv "$file" "$target"
    fi
  done
fi

echo_success "Finished linking dotfiles"
