#!/bin/bash

# Color definitions for output
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print a header with a line underneath
print_header() {
    echo -e "\n${BOLD}${CYAN}$1${NC}"
    echo -e "${CYAN}$(printf '%*s' ${#1} '' | tr ' ' '─')${NC}"
}

# Create a symlink from dotfiles to home directory
symlink_to_home() {
    local source="$1"
    local target="$HOME/$(basename "$source")"
    
    # Expand ~ to actual home directory
    source="${source/#\~/$HOME}"
    
    if [[ -L "$target" ]]; then
        echo "Symlink already exists: $target"
    elif [[ -f "$target" ]] || [[ -d "$target" ]]; then
        echo "Backing up existing file/directory: $target"
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        ln -s "$source" "$target"
        echo "Created symlink: $target → $source"
    else
        ln -s "$source" "$target"
        echo "Created symlink: $target → $source"
    fi
}

branch() {
  current_date=$(date +'%d.%m.%y')
  git checkout -b p7/$current_date/$1
}

remove_local_branches() {
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

# Source a file only if it exists.
# Use for files that might not be on all machines (work-specific).
safe_source () {
  if [ -f $1 ]; then source $1; fi
}

# Print a message in color.
# https://bytefreaks.net/gnulinux/bash/cecho-a-function-to-print-using-different-colors-in-bash
cecho () {
  declare message=${1:-""}
  declare   color=${2:-"default"}

  # Use case statement instead of associative array for bash 3.2 compatibility
  case "$color" in
    "default")      color_code="\e[39m" ;;
    "black")        color_code="\e[30m" ;;
    "red")          color_code="\e[31m" ;;
    "green")        color_code="\e[32m" ;;
    "yellow")       color_code="\e[33m" ;;
    "blue")         color_code="\e[34m" ;;
    "magenta")      color_code="\e[35m" ;;
    "cyan")         color_code="\e[36m" ;;
    "gray")         color_code="\e[37m" ;;
    "light-red")    color_code="\e[91m" ;;
    "light-green")  color_code="\e[92m" ;;
    "light-yellow") color_code="\e[93m" ;;
    "light-blue")   color_code="\e[94m" ;;
    "light-magenta") color_code="\e[95m" ;;
    "light-cyan")   color_code="\e[96m" ;;
    "light-gray")   color_code="\e[97m" ;;
    *)              color_code="\e[39m" ;;
  esac

  echo -e "\x01${color_code}\x02${message}\x01\e[m\x02"
}

# Given a file path, make it executable
make_executable () {
  declare file=$1

  # Only take action if the input file exists
  if [[ -f $file ]]; then
    echo "Making $(basename "$file") executable"
    chmod +x "$file"
  fi
}

# Print a colored header for setup sections
print_header () {
  declare message=${1:-""}
  echo
  cecho "=== $message ===" "cyan"
  echo
}

# Create a symlink from dotfiles to home directory
symlink_to_home () {
  declare source_file=$1
  declare target_file="${HOME}/$(basename "$source_file")"
  
  # Expand the ~ in source_file to full path
  source_file="${source_file/#\~/$HOME}"
  
  if [[ -f $source_file ]] || [[ -d $source_file ]]; then
    echo "Linking $(basename "$source_file")"
    
    # Remove existing file/symlink if it exists
    [[ -L "$target_file" ]] && rm "$target_file"
    [[ -f "$target_file" ]] && mv "$target_file" "${target_file}.backup"
    [[ -d "$target_file" ]] && mv "$target_file" "${target_file}.backup"
    
    # Create the symlink
    ln -s "$source_file" "$target_file"
  else
    echo "Warning: Source file $source_file does not exist"
  fi
}
