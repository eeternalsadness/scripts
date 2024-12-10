#!/usr/bin/env bash

zip_file_name="kv-obsidian.zip"

if [[ ! -d $OBSIDIAN ]]; then
  echo "Cannot find Obsidian folder at '$OBSIDIAN'. Please check if the path is correct."
fi

cd $OBSIDIAN

zip -ur "$zip_file_name" *
