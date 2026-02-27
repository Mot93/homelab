#!/bin/bash

compose_folder="$(cd "$(dirname $0)" && pwd)"
global_env="$compose_folder/config.env"

if [ -f $global_env ]; then
  source $global_env
  export DOCKER_VOLUMES
else
  echo "Missing $global_env file in the root folder"
  exit 5
fi

do_backup=true

while getopts ":r:" opt; do
  case $opt in
    # -r creates a backup
    r)
      backup_file="$OPTARG"
      tar -xvzf $backup_file --directory $DOCKER_VOLUMES
      do_backup=false
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 3
      ;;
  esac
done

if [ "$do_backup" == "true" ]; then
  backup_name="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
  tar czf $backup_name --directory "$(dirname "$DOCKER_VOLUMES")" "$(basename "$DOCKER_VOLUMES")"
fi
