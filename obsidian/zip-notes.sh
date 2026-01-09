#!/usr/bin/env bash

zip_file_name="kv-obsidian.zip"

if [[ ! -d "$OBSIDIAN" ]]; then
  echo "Cannot find Obsidian folder at '$OBSIDIAN'. Please check if the path is correct."
fi

cd "$OBSIDIAN" || exit 1

echo "Deleting old archive..."
rm "$zip_file_name"
echo "Zipping notes..."
zip -r "$zip_file_name" *
