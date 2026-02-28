#!/bin/bash

# Simple use
# log "ERROR" "The application crashed"
# Storing logs into 
# log "INFO" "Script started" "log_file.log"

# Log function
log() {
    if [ ! $# -ge 2 ]; then
        echo "ERROR: 2 argument are required: <level> <message>"
        exit 1
    fi
    # Get level, message and file where to store
    local level=$1
    local message=$2
    # Config logs
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    if [ "$level" == "SUCCESS" ]; then
        local log_entry="[$timestamp] [INFO] $message"
    else
        local log_entry="[$timestamp] [$level] $message"
    fi

    # Color config
    # Define colors
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local PURPLE='\033[0;35m'
    local NC='\033[0m' # No Color

    # Print to console with color
    case $level in
        "SUCCESS")
            echo -e "${GREEN}$log_entry${NC}"
            ;;
        "INFO")
            echo -e "${CYAN}$log_entry${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}$log_entry${NC}"
            ;;
        "ERROR")
            echo -e "${RED}$log_entry${NC}" >&2
            ;;
        *)
            echo -e "${PURPLE}$log_entry${NC}"
            ;;
    esac

    # The third postional argument should be the directory where to store the log
    # Check if the third positional argument has been passed
    if [ -n "$3" ]; then
        local log_file="$3"
        local log_dir=$(dirname $log_file)
        if [ -d $log_dir ]; then
            # Create the log file if it doesn't exist
            touch "$log_file"

            # Print to log file (no color)
            echo "$log_entry" >> "$log_file"
        else
            echo -e "${RED}The log '$message' cannot be stored because the directory '$log_dir' does not exists${NC}"
            exit 1
        fi
    fi
}

export -f log
