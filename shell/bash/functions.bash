#!/bin/bash

# Show colorful chevrons according to what season it is.
chevrons () {
  local date=$(date)
  local chevrons="❯❯❯"

  case $date in
    # spring
    *Mar*|*Apr*|*May*)
      chevrons="❯❯❯"
      ;;
    # summer
    *Jun*|*Jul*|*Aug*)
      chevrons="❯❯❯"
      ;;
    # fall
    *Sep*|*Oct*|*Nov*)
      chevrons="❯❯❯"
      ;;
    # winter
    *Dec*|*Jan*|*Feb*)
      chevrons="❯❯❯"
      ;;
    *)
      ;;
  esac

  echo $chevrons
}

# Return the branch name if we're in a git repo, or nothing otherwise.
git_check () {
  local gitBranch=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
  if [[ $gitBranch ]]; then
    echo -n $gitBranch
    return
  fi
}

# Return the status of the current git repo.
git_status () {
  local gitBranch="$(git_check)"
  if [[ $gitBranch ]]; then
    local statusCheck=$(git status 2> /dev/null)
    if [[ $statusCheck =~ 'Your branch is ahead' ]]; then
      echo -n 'ahead'
    elif [[ $statusCheck =~ 'Changes to be committed' ]]; then
      echo -n 'staged'
    elif [[ $statusCheck =~ 'no changes added' ]]; then
      echo -n 'modified'
    elif [[ $statusCheck =~ 'working tree clean' ]]; then
      echo -n 'clean'
    fi
  fi
}

# Return a color based on the current git status.
git_status_color () {
  local gitStatus="$(git_status)"
  local statusText=''
  case $gitStatus in
    clean*)
      statusText="green"
      ;;
    modified*)
      statusText="magenta"
      ;;
    staged*)
      statusText="yellow"
      ;;
    ahead*)
      statusText="cyan"
      ;;
    *)
      statusText="white"
      ;;
  esac
  echo -n $statusText
}

# Print a label for the current git branch if it isn't main or master.
git_branch () {
  local gitBranch="$(git_check)"
  echo -n "⌥ $gitBranch"
}

# Print a dot indicating the current git status.
git_dot () {
  local gitCheck="$(git_check)"
  if [[ $gitCheck ]]; then
    local gitStatus="$(git_status)"
    local gitStatusDot='●'
    if [[ $gitStatus == 'staged' ]]; then
      local gitStatusDot='◍'
    elif [[ $gitStatus == 'modified' ]]; then
      local gitStatusDot='○'
    fi
    if [[ $gitCheck && ! $gitCheck =~ (main|master) && $COLUMNS -lt 80 ]]; then
      echo -n "⌥ "
    fi
    echo -n "$gitStatusDot "
  fi
}

# Get the current directory, truncate it, and make it blue
fancy_dir () {
  echo -n "$(pwd)"
  return
}

# Kill processes running on a specific port
killport() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: killport <port_number>"
    echo "Example: killport 3000"
    return 1
  fi

  local port=$1
  local pids=$(lsof -ti:$port)

  if [[ -z $pids ]]; then
    echo "No processes found running on port $port"
    return 0
  fi

  echo "Killing processes on port $port: $pids"
  echo $pids | xargs kill -9
  echo "Processes killed successfully"
}

