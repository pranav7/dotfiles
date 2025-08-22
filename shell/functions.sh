#!/bin/false

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

  declare -A colors
  colors=(
          [default]="\e[39m"
            [black]="\e[30m"
              [red]="\e[31m"
            [green]="\e[32m"
           [yellow]="\e[33m"
             [blue]="\e[34m"
          [magenta]="\e[35m"
             [cyan]="\e[36m"
             [gray]="\e[37m"
        [light-red]="\e[91m"
      [light-green]="\e[92m"
     [light-yellow]="\e[93m"
       [light-blue]="\e[94m"
    [light-magenta]="\e[95m"
       [light-cyan]="\e[96m"
       [light-gray]="\e[97m"
  )

  color=${colors[$color]}

  echo -e "\x01${color}\x02${message}\x01\e[m\x02"
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
