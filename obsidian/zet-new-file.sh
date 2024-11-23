#!/bin/bash

file_name=""

if [[ -n $1 ]]; then
    file_name=$1
else
    read -rp "Enter the file name: " file_name
fi

file_path="$OBSIDIAN_INBOX/${file_name}.md"

# create file only if it doesn't exist
if [[ ! -f "$file_path" ]]; then
    cat >"$file_path" <<EOT
# ${file_name}

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT

    # NOTE: append to daily note
    daily_file_name="$(date +"%Y-%m-%d")"
    daily_file_path="$OBSIDIAN/Periodic Notes/0-Daily/${daily_file_name}.md"

    if [[ ! -f "$daily_file_path" ]]; then
        bash $SCRIPTS/obsidian/daily-note.sh
    fi

    echo "[[$file_name]]" >>"$daily_file_path"
fi

# no file name provided, open neovim
if [[ -z $1 ]]; then
    nvim -c "cd $OBSIDIAN" "$file_path"
fi
