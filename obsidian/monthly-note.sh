#!/bin/bash

file_name="$(date +"%Y-%m").md"
file_path="$OBSIDIAN/Periodic Notes/2-Monthly/$file_name"

# create file only if it doesn't exist
if [[ ! -f "$file_path" ]]; then
    cat >"$file_path" <<EOT
# ${file_name}

<< [[$(date -d "last month" +"%Y-%m")]] | [[$(date -d "next month" +"%Y-%m")]] >>

## Monthly Quests

- [ ] Study

## $(date +"%Y-%m") Recap

## Reflections

### What did you accomplish this month?

### What could you have done better?

### What are some of the notable things that happened this month?

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
else
    echo "Monthly note '$file_name' already exists"
fi
