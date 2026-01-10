#!/bin/bash

notes_dir="$1"
pattern="$2"

files=()
while read -r file; do
  files+=("$file")
done < <(find "$notes_dir" -type f -name "$pattern")

for file in "${files[@]}"; do
  # use h1 for file name
  header=$(head -n 1 "$file" | sed 's/^# //')
  new_name="${header}.md"
  dir_name=$(dirname "$file")
  new_path="${dir_name}/${new_name}"

  mv "$file" "$new_path"
done
