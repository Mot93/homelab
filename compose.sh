#!/bin/bash

validate_env() {
  folder=$1
  # echo "validating $folder"
  # Check if the folder exists
  if [ ! -d "$folder" ]; then
    echo "Folder $1 doesn't exist."
    exit 1
  # Check if the compose.yaml file exists in the folder
  elif [ ! -f $compose_file ]; then
    echo "Compose file $compose_file doesn't exists"
    exit 2
  fi
  echo "$folder valid"
}

compose_files=()

# If the character * is passed insteas of the name of an existing folder execute the command for each folder with a compose.yaml file
if [ "$1" = "all" ]; then # 
  compose_files=$( find . -name "compose.yaml" -type f )
  echo "environments found:"
  for compose in $compose_files; do
    echo $compose
  done
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

global_env="./.env"
if [ -f $global_env ]; then
  source $global_env
  export DOCKER_VOLUMES
else
  echo "Missing $global_env file in the root folder"
  exit 5
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
      compose_restart=true
      ;;
    # -p pull the images defined in a compose file
    p)
      pull_images=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 3
      ;;
  esac
done

# Looping over all the compose file specified
for compose_file in $compose_files; do
  # Main switch-case logic based on flag values
  command=""
  case "$compose_down,$remove_images,$pull_images,$compose_restart" in
    true,false,*,*)
      command="down"
      ;;
    true,true,*,*)
      command="down --rmi all"
      ;;
    false,true,*,*)
      # Cannot delete an image if the a container is using it
      # Force to stop all containers instances before deleting image
      echo "To use -e it's also necessary to use -d. Example ./compose.sh -ed"
      exit 4
      ;;
    *,*,*,true)
      command="restart"
      ;;
    *,*,true,*)
      command="pull"
      ;;
    *)
      command="up -d"
      ;;
  esac
  docker compose --file $compose_file $command
done
