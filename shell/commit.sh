#!/bin/false

function commit() {
  local model="llama3.2"
  local commit_msg=""
  local debug=false
  local has_explicit_message=false

  # Process arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --debug)
        debug=true
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
      --message|-m)
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
        echo "Usage: commit [--debug] [--model MODEL_NAME] [--message|-m \"COMMIT_MESSAGE\"] [MODEL_NAME] [\"COMMIT_MESSAGE\"]"
        return 1
        ;;
      *)
        # If not a recognized option or model, treat as commit message
        # Only if we haven't already set a message with --message/-m
        if [ "$has_explicit_message" = false ]; then
          commit_msg="$1"
          has_explicit_message=true
        else
          echo "Error: Multiple commit messages provided"
          return 1
        fi
        shift
        ;;
    esac
  done

  # Debug information
  if [ "$debug" = true ]; then
    echo "Debug: Using model: $model"
    if [ -n "$commit_msg" ]; then
      echo "Debug: Using provided commit message: $commit_msg"
    else
      echo "Debug: Will generate commit message using $model"
    fi
  fi

  # Check if any files are staged
  if [ -z "$(git diff --cached --name-only)" ]; then
    echo "⤫ No files staged"
    echo "✓ Staging all files ..."

    git add .
  fi

  # Create a temporary file for the git diff
  local diff_file=$(mktemp)
  # Get the git diff and save it to the temporary file
  git --no-pager diff --cached > "$diff_file"

  # Check if there are changes to commit
  if [ ! -s "$diff_file" ]; then
    echo "❌ No changes to commit."
    rm "$diff_file"
    return 1
  fi

  # If no commit message was provided, generate one using ollama
  if [ -z "$commit_msg" ]; then
    echo "✓ Generating commit message using model: $model"

    # Create the prompt
    local prompt="
    Create a commit message for the following changes:

    Here are the changes:
    $(cat "$diff_file")

    IMPORTANT: Follow these instructions when creating the commit message
    - Your response should be ONLY the commit message without any additional explanations
    - Keep the commit message short, and concise, ideally less than 50 characters
    - Do not use single or double quotes for the commit message, simply output the commit message
    - Do not use prefixes like 'feat', 'feature', 'changes'
    - Do not use any punctuations
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

  local branch=$(git symbolic-ref --short HEAD)
  # Confirm the commit was made
  echo "\n✓ Commit created"
  echo "⬆️ Pushing changes to $branch"
  echo "---------------------------------\n"

  git push origin $branch

  echo "\n---------------------------------"
  echo "✅ All done"
}