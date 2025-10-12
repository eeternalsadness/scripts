symlink_dotfiles() {
  local dotfiles_dir=${1:-$REPO/personal/dotfiles}
  local scripts_dir=${2:-$SCRIPTS}

  source "$scripts_dir/common/echo.sh"

  # show warning and prompt for confirmation
  echo_warning "This script will symlink all dotfiles in $dotfiles_dir to the home directory ($HOME)."
  echo_warning "All directories in $dotfiles_dir/.config/ will also be symlinked to $HOME/.config/."
  echo_warning "All files and directories will be backed up (with versioning) by default."

  read -rp "Proceed? [y/n]: " user_input
  case "$user_input" in
  "y") ;;
  "n") return 1 ;;
  *)
    echo_error "Invalid input: '$user_input'."
    return 1
    ;;
  esac

  # symlink dotfiles
  echo "Linking dotfiles..."

  for file in "$dotfiles_dir"/.*; do
    file_name=$(basename "$file")

    # Ignore folders & special files
    if [[ -d "$file" ]] || [[ "$file_name" == ".gitignore" ]]; then
      continue
    fi

    target="$HOME/$file_name"

    # create symlink with versioned backup
    symlink_target=$(readlink "$target")
    if [[ "$symlink_target" == "$file" ]]; then
      echo "Symlink '$target' -> '$symlink_target' already exists!"
    else
      echo "Creating symlink for '$file' at '$target'"
      VERSION_CONTROL=t ln -sbv "$file" "$target"
    fi
  done

  # symlink dirs in .config/
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

    # back up target dir if it exists
    if [[ -d "$target" ]]; then
      VERSION_CONTROL=t mv -bTv "$target" "${target}.backup"
    fi

    # create symlink
    symlink_target=$(readlink "$target")
    if [[ "$symlink_target" == "$file" ]]; then
      echo "Symlink '$target' -> '$symlink_target' already exists!"
    else
      echo "Creating symlink for '$file' at '$target'"
      VERSION_CONTROL=t ln -sbv "$file" "$target"
    fi
  done

  echo_success "Finished linking dotfiles"
}
