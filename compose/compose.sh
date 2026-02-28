#!/bin/bash

# set -e

# Check if the specified folder exists and if it contains a compose.yaml file
validate_env() {
  local folder=$1
  local log_file=$2
  local compose_file="$folder/compose.yaml"
  # Check if the folder exists
  if [ ! -d "$folder" ]; then
    log "ERROR" "Folder $1 doesn't exist." $log_file
    exit 1
  # Check if the compose.yaml file exists in the folder
  elif [ ! -f $compose_file ]; then
    log "ERROR" "Compose file $compose_file doesn't exists" $log_file
    exit 2
  fi
  log "INFO" "$folder valid"
}

compose_folder="$(cd "$(dirname $0)" && pwd)"
root_folder="$(cd "$(dirname $0)"/.. && pwd)"

source $root_folder/common/logs.sh

# Config
compose_files=()
apps=$1
timestamp=$(date +'%Y-%m-%d')
log_file="$root_folder/logs/compose-$timestamp.log"

# If the string installed is passed execute the command on the environment specified in the var 
if [ "$1" = "installed" ]; then
  log "INFO" "Working on compose defined in the env variable INSTALLED" $log_file
  source "$compose_folder/hidden.env"
  apps=$INSTALLED
fi

# If the string all is passed execute the command for each folder with a compose.yaml file
if [ "$apps" = "all" ]; then
  compose_files=$( find "$compose_folder/" -name "compose.yaml" -type f )
  log "INFO" "Keyword all used" $log_file
  for compose in $compose_files; do
    log "INFO" "Compose found: $compose" $log_file
  done
# Check if multiple environments separated by a comma are passed
elif [[ "$apps" == *","* ]]; then 
  log "INFO" "Multiple applications specified" $log_file
  IFS=',' read -ra folders <<< "$apps"
  for folder in "${folders[@]}"; do
    folder_path="$compose_folder/$folder"
    validate_env $folder_path $log_file
    compose_files+=" $folder_path/compose.yaml"
  done
# Working on a single environment
else
  validate_env $compose_folder/$1 $log_file
  compose_files="$compose_folder/$1/compose.yaml"
fi

global_env="$compose_folder/config.env"
if [ -f $global_env ]; then
  source $global_env
  export DOCKER_VOLUMES
else
  log "ERROR" "Missing 'config.env' file in the compose folder" $log_file
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
      log "ERROR" "Invalid option: -$OPTARG" $log_file
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
      log "ERROR" "To use -e it's also necessary to use -d. Example ./compose.sh -ed" $log_file
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
  compose="docker compose --file $compose_file $command"
  log "INFO" "$compose" $log_file
  eval $compose
done
