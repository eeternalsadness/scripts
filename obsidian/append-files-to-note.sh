#!/bin/bash

notes_dir="$1"
pattern="$2"
note_file="$3"

files=()
while read -r file; do
  files+=("$file")
done < <(find "$notes_dir" -type f -name "$pattern")

for file in "${files[@]}"; do
  file_name=$(basename "$file" | sed 's/.md$//')

  echo '[['$file_name']]' >>"$note_file"
done
