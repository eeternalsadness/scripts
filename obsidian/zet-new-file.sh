#!/bin/bash

file_name=""

if [[ -n $1 ]]; then
  file_name=$1
else
  read -rp "Enter the file name: " file_name
fi

file_name="${file_name}.md"

# create file only if it doesn't exist
if [[ ! -f $OBSIDIAN_INBOX/$file_name ]]; then
  cat <<EOT >$OBSIDIAN_INBOX/$file_name


---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
fi

# no file name provided, open neovim
if [[ -z $1 ]]; then
  nvim -c "cd $OBSIDIAN" $OBSIDIAN_INBOX/$file_name
fi
