#!/bin/bash

# If the character * is passed insteas of the name of an existing folder execute the command for each folder with a compose.yaml file
if [ "$1" = "all" ]; then # 
  compose_files=$( find . -name "compose.yaml" -type f )
  echo $compose_files
elif [ ! -d "$1" ]; then # Check if the environment exists
  echo "Folder $1 doesn't exist."
  exit 1
fi

# Working on a single directory instead of multiple ones
# Inside the specified folder, the compose file has to exists
if [ "$1" != "all" ]; then
  compose_file="$1/compose.yaml"
  if [ ! -f $compose_file ]; then
    echo "Compose file $compose_file doesn't exists"
    exit 2
  fi
  compose_files=($compose_file)
fi

# Initialize flags
compose_down=false
remove_images=false
pull_images=false
compose_restart=false

# Managing flags
shift # Move past the first argument so getopts can read flags
while getopts ":depr" opt; do
  case $opt in
    # -d instead of docker compose up, run docker compose down
    d)
      compose_down=true
      ;;
    # -e removes all imges from the machine
    e)
      remove_images=true
      ;;
    # -r restart all the containers in the machine
    r)
      remove_images=true
      ;;
    # -p update the image of the container 
    # This is ment for all the 
    p)
      pull_images=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Main switch-case logic based on flag values
for compose_file in $compose_files; do
  case "$compose_down,$remove_images,$pull_images,$compose_restart" in
    true,false,*,*)
      docker compose --file $compose_file down
      ;;
    true,true,*,*)
      docker compose --file $compose_file down
      docker compose --file $compose_file down --rmi 'all'
      ;;
    *,*,*,true)
      docker compose --file $compose_file restart
      ;;
    *,*,true,*)
      docker compose --file $compose_file pull
      ;;
    *)
      docker compose --file $compose_file up -d
      ;;
  esac
done
