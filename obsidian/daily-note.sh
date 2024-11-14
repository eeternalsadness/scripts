#!/bin/bash

file_name="$(date +"%Y-%m-%d").md"

# create file only if it doesn't exist
if [[ ! -f "$OBSIDIAN/Periodic Notes/0-Daily/$file_name" ]]; then
    cat >"$OBSIDIAN/Periodic Notes/0-Daily/$file_name" <<EOT
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

### What are some of the notable things that happened today?

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
else
    echo "Daily note '$file_name' already exists"
fi
