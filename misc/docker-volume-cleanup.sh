# NOTE: delete docker volumes that are more than X days old
cutoff=$(date -d '30 days ago' +%s)
for vol in $(docker volume ls -q); do
  created=$(docker volume inspect "$vol" --format '{{ .CreatedAt }}')
  created_ts=$(date -d "$created" +%s)
  if [[ $created_ts -lt $cutoff ]]; then
    echo "Deleting $vol (created $created)"
    docker volume rm "$vol"
  fi
done
