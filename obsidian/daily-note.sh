#!/bin/bash

file_name="$(date +"%Y-%m-%d")"
file_path="$OBSIDIAN/Periodic Notes/0-Daily/${file_name}.md"

# create file only if it doesn't exist
if [[ ! -f "$file_path" ]]; then
    cat >"$file_path" <<EOT
# ${file_name}

<< [[$(date -d "yesterday" +"%Y-%m-%d")]] | [[$(date -d "tomorrow" +"%Y-%m-%d")]] >>

## Daily Tasks

- [x] Process notes
- [ ] Run
- [ ] Study

## Logs

## Reflections

### How do you feel today?

### What did you accomplish today?

### What could you have done better?

### What are some notable things that happened today?

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
else
    echo "Daily note '$file_name' already exists"
fi
