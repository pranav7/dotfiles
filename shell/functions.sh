#!/bin/false

branch() {
  current_date=$(date +'%d.%m.%y')
  git checkout -b p7/$current_date/$1
}

remove_local_branches() {
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

function llamagc() {
    # Create a temporary file for the git diff
    local diff_file=$(mktemp)

    # Get the git diff and save it to the temporary file
    git --no-pager diff HEAD --raw -p > "$diff_file"

    # Use ollama to generate a commit message based on the diff
    local commit_msg=$(ollama run llama3.2 "Generate a single, concise line that describes these git changes (be brief and specific): $(cat "$diff_file")" 2>/dev/null | head -n 1)

    # Cleanup temporary file
    rm "$diff_file"

    # If we got a message, commit with it; otherwise, abort
    if [ -n "$commit_msg" ]; then
        echo "Committing with message: $commit_msg"
        echo "$commit_msg" | git commit -a --file -
    else
        echo "Failed to generate commit message. Aborting commit."
        return 1
    fi
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
