#!/bin/bash

file_name="$(date +"%Y-W%W").md"

# create file only if it doesn't exist
if [[ ! -f "$OBSIDIAN/Periodic Notes/1-Weekly/$file_name" ]]; then
    cat >"$OBSIDIAN/Periodic Notes/1-Weekly/$file_name" <<EOT
# ${file_name}

<< [[$(date -d "last week" +"%Y-W%W")]] | [[$(date -d "next week" +"%Y-W%W")]] >>

## Weekly Quests

- [ ] Run 4/7 days, 30 minutes per run
- [ ] Study 1 hour everyday

## Logs

## Reflections

### What did you accomplish this week?

### What could you have done better?

### What are some of the notable things that happened this week?

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
else
    echo "Weekly note '$file_name' already exists"
fi
