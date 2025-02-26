#!/bin/false

branch() {
  current_date=$(date +'%d.%m.%y')
  git checkout -b p7/$current_date/$1
}

remove_local_branches() {
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

function commit() {
  # Allow a model to be specified as an argument, default to gemma2:2b
  # local model="${1:-gemma2:2b}"
  local model="${1:-llama3.2}"

  # Check if any files are staged
  if [ -z "$(git diff --cached --name-only)" ]; then
    echo "No files staged. Staging all changes..."
    git add .
  fi

  # Create a temporary file for the git diff
  local diff_file=$(mktemp)
  # Get the git diff and save it to the temporary file
  git --no-pager diff --cached --raw -p > "$diff_file"

  # Check if there are changes to commit
  if [ ! -s "$diff_file" ]; then
    echo "☝️ No changes to commit."
    rm "$diff_file"
    return 1
  fi

  # Use ollama to generate a commit message based on the diff
  echo "🤖 Generating commit message using model: $model"
  local commit_msg=$(ollama run "$model" "
  Create a commit message for the following changes:

  Here are the changes:
  $(cat "$diff_file")

  Keep the following instructions in mind:
  - Your response should be ONLY the commit message without any additional explanations
  - Keep the commit message short, and concise, ideally less than 50 characters
  - Do not use single or double quotes for the commit message, simply output the commit message
  - Do not use prefixes like 'feat', 'feature', 'changes' 
  " 2>/dev/null)

  # Cleanup temporary file
  rm "$diff_file"

  # Display the generated message
  echo "🤖 Generated commit message:"
  echo "$commit_msg"

  echo "✔️ Committing with this message..."
  git commit -m "$commit_msg"

  # Confirm the commit was made
  echo "✔️ Commit created."
  echo "Pushing changes"
  git push origin $(git symbolic-ref --short HEAD)
  echo "✅ Finished commiting and pushing changes"
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
