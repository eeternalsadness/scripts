#!/bin/bash

file_name="$(date +"%Y")"
file_path="$OBSIDIAN/Periodic Notes/3-Yearly/${file_name}.md"

# create file only if it doesn't exist
if [[ ! -f "$file_path" ]]; then
    cat >"$file_path" <<EOT
# ${file_name}

<< [[$(date -d "last year" +"%Y-%m")]] | [[$(date -d "next year" +"%Y-%m")]] >>

## $(date +"%Y") Resolutions

- [ ] Resolution #1
- [ ] Resolution #2

## $(date +"%Y") Recap

## Reflections

### What did you accomplish this year?

### What made you proud?

### What could you have done better?

### What are some notable things that happened this year?

---

$(date +'%Y%m%d%H%M')

Tags:

Links:
EOT
else
    echo "Yearly note '$file_name' already exists"
fi
