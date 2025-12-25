#!/bin/bash

# Check if the environment exists
if [ ! -d "$1" ]; then
  echo "$1 does not exist."
  exit 1
fi

# Check if the file compose.yaml exists, if it doesn't: exit the script
compose_file="$1/compose.yaml"
if [ ! -f $compose_file ]; then
  echo "$compose_file doesn't exists"
  exit 2
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
