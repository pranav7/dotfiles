#!/bin/false

function commit() {
  local model="llama3.2"
  # local model="gpt-oss"
  local commit_msg=""
  local debug=false
  local has_explicit_message=false
  local push=false
  local positional_args=()

  # Process arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --debug)
      debug=true
      shift
      ;;
    --push | --p)
      push=true
      shift
      ;;
    --model)
      if [[ $# -gt 1 ]]; then
        model="$2"
        shift 2
      else
        echo "Error: --model requires a model name"
        return 1
      fi
      ;;
    --message | -m)
      if [[ $# -gt 1 ]]; then
        commit_msg="$2"
        has_explicit_message=true
        shift 2
      else
        echo "Error: --message requires a commit message"
        return 1
      fi
      ;;
    -*)
      # Unknown flag
      echo "Error: Unknown flag $1"
      echo "Usage: commit [--debug] [--push|--p] [--model MODEL_NAME] [--message|-m \"COMMIT_MESSAGE\"] [\"COMMIT_MESSAGE\"]"
      return 1
      ;;
    *)
      # Store positional arguments for later processing
      positional_args+=("$1")
      shift
      ;;
    esac
  done

  # Process positional arguments if any
  if [[ ${#positional_args[@]} -gt 0 && "$has_explicit_message" = false ]]; then
    commit_msg="${positional_args[0]}"
    has_explicit_message=true
  elif [[ ${#positional_args[@]} -gt 1 ]]; then
    echo "Error: Multiple commit messages provided"
    return 1
  fi

  # Check if any files are staged
  if [ -z "$(git diff --cached --name-only)" ]; then
    echo "⚠️ No files staged"
    echo "✓ Staging all files ..."

    git add .
  fi

  # Create a temporaryfile for the git diff
  local diff_file=$(mktemp)
  # Get the git diff and save it to the temporary file
  git --no-pager diff --cached >"$diff_file"

  # Check if there are changes to commit
  if [ ! -s "$diff_file" ]; then
    echo "⚠️ No changes to commit."
    rm "$diff_file"
    return 1
  fi

  # Collect context to help generate a better commit message
  local repo_name
  repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
  local branch_name
  branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)
  local staged_files
  staged_files=$(git --no-pager diff --cached --name-only)
  local staged_count
  staged_count=$(printf "%s\n" "$staged_files" | sed '/^$/d' | wc -l | tr -d ' ')
  local staged_name_status
  staged_name_status=$(git --no-pager diff --cached --name-status)
  local recent_subjects
  recent_subjects=$(git --no-pager log -n 10 --pretty=format:'- %s' 2>/dev/null)

  # If no commit message was provided, generate one using ollama
  if [ -z "$commit_msg" ]; then
    echo "✓ Generating commit message using model: $model"

    # Create the prompt
    local prompt="
    Write a Git commit message for the changes shown below.

    IMPORTANT RULES:
    - Output ONLY the commit message
    - NO prefixes like feat:, fix:, docs:, style:, refactor:, test:, chore:
    - NO type tags or conventional commit format
    - Start with a verb: Add, Update, Fix, Remove, Improve, Refactor, etc.
    - First line max 72 characters
    - Be specific and descriptive

    EXAMPLE GOOD COMMIT MESSAGES:
    - Update commit message prompt to remove type prefixes
    - Add validation for user input in login form
    - Fix memory leak in database connection handler
    - Improve performance of search algorithm by 40%
    - Remove deprecated API endpoints from v1

    PROJECT INFO:
    Repository: ${repo_name}
    Branch: ${branch_name}
    Files changed (${staged_count}):
$(printf "%s\n" "$staged_files" | sed 's/^/    /')

    CHANGES:
    $(cat "$diff_file")

    Write the commit message now:
    "

    # Print the prompt if debug is enabled
    if [ "$debug" = true ]; then
      echo "Debug: Sending the following prompt to $model:"
      echo "--------- PROMPT START ---------"
      echo "$prompt"
      echo "---------- PROMPT END ----------"
    fi

    commit_msg=$(ollama run "$model" "$prompt" 2>/dev/null)

    echo "✓ Commit message generated: $commit_msg"
  else
    echo "✓ Using provided commit message: $commit_msg"
  fi

  # Cleanup temporary file
  rm "$diff_file"

  echo "✓ Creating commit"
  echo "---------------------------------\n"
  git commit -m "$commit_msg"

  # Check if we should push
  if [ "$push" = true ]; then
    local branch=$(git symbolic-ref --short HEAD)
    # Confirm the commit was made
    echo "\n✓ Commit created"
    echo "⬆️ Pushing changes to $branch"
    echo "---------------------------------\n"

    git push origin $branch

    echo "\n---------------------------------"
    echo "✅ All done"
  else
    echo "\n✓ Commit created"
    echo "\n---------------------------------"
    echo "✅ Commit completed"
  fi
}
