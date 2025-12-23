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

# Managing flags
shift # Move past the first argument so getopts can read flags
while getopts ":dr" opt; do
  case $opt in
    # -d instead of docker compose up, run docker compose down
    d)
      compose_down=true
      ;;
    # -r removes all imges from the machine
    r)
      remove_images=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ "$compose_down" = true ]; then
  docker compose --file $compose_file down
  if [ "$remove_images" = true ]; then
    docker compose --file $compose_file down --rmi 'all'
  fi
else
  docker compose --file $compose_file up -d 
fi
