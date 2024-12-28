#!/bin/bash

file_name=""

if [[ -n $1 ]]; then
  file_name=$1
else
  read -rp "Enter the file name: " file_name
fi

file_path="$OBSIDIAN_INBOX/${file_name}.md"

# create file only if it doesn't exist
find_output=$(find "${OBSIDIAN}/" -type f -name "${file_name}.md")
if [[ -z "$find_output" ]]; then
  cat >"$file_path" <<EOT
# ${file_name}

---

$(date +'%Y%m%d%H%M')

Tags:

Links:

EOT
  create_note_success=$?

  # NOTE: append to daily note
  daily_file_name="$(date +"%Y-%m-%d")"
  daily_file_path="$OBSIDIAN/Periodic Notes/0-Daily/${daily_file_name}.md"

  if [[ ! -f "$daily_file_path" ]]; then
    bash $SCRIPTS/obsidian/daily-note.sh
  fi

  [[ "$create_note_success" == 0 ]] && echo "[[$file_name]]" >>"$daily_file_path"
else
  echo "File '$file_name' already exists at '$find_output'"
fi

# no file name provided, open neovim
if [[ -z $1 ]]; then
  nvim -c "cd $OBSIDIAN" "$file_path"
fi
