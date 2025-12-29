#!/bin/bash

validate_env() {
  folder=$1
  echo "validating $folder"
  # Check if the folder exists
  if [ ! -d "$folder" ]; then
    echo "Folder $1 doesn't exist."
    exit 1
  # Check if the compose.yaml file exists in the folder
  elif [ ! -f $compose_file ]; then
    echo "Compose file $compose_file doesn't exists"
    exit 2
  fi
}

compose_files=()

# If the character * is passed insteas of the name of an existing folder execute the command for each folder with a compose.yaml file
if [ "$1" = "all" ]; then # 
  compose_files=$( find . -name "compose.yaml" -type f )
  echo $compose_files
# Check if multiple environments separated by a comma are passed
elif [[ "$1" == *","* ]]; then 
  IFS=',' read -ra folders <<< "$1"
  for folder in "${folders[@]}"; do
    validate_env $folder
    compose_files+=" $folder/compose.yaml"
  done
# Working on a single environment
else
  validate_env $1
  compose_files="$1/compose.yaml"
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
    # -e removes all images from the machine
    e)
      remove_images=true
      ;;
    # -r restart all the containers in the machine
    r)
      remove_images=true
      ;;
    # -p pull the images defined in a compose file
    p)
      pull_images=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Looping over all the compose file specified
for compose_file in $compose_files; do
  # Main switch-case logic based on flag values
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
