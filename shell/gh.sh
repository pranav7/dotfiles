#!/bin/false

function commit() {
  local model="llama3.2"
  local commit_msg=""
  local debug=false
  local has_explicit_message=false
  local positional_args=()

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
        echo "Usage: commit [--debug] [--model MODEL_NAME] [--message|-m \"COMMIT_MESSAGE\"] [\"COMMIT_MESSAGE\"]"
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

function pr() {
  local title=""
  local body=""
  local base=""
  local head=""
  local debug=false
  local web=false
  local draft=false
  local auto=false
  local model="llama3.2"
  local positional_args=()

  # Process arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --debug)
        debug=true
        shift
        ;;
      --web|-w)
        web=true
        shift
        ;;
      --draft|-d)
        draft=true
        shift
        ;;
      --auto|-a)
        auto=true
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
      --title|-t)
        if [[ $# -gt 1 ]]; then
          title="$2"
          shift 2
        else
          echo "Error: --title requires a value"
          return 1
        fi
        ;;
      --body|-b)
        if [[ $# -gt 1 ]]; then
          body="$2"
          shift 2
        else
          echo "Error: --body requires a value"
          return 1
        fi
        ;;
      --base)
        if [[ $# -gt 1 ]]; then
          base="$2"
          shift 2
        else
          echo "Error: --base requires a branch name"
          return 1
        fi
        ;;
      -*)
        # Unknown flag
        echo "Error: Unknown flag $1"
        echo "Usage: pr [--debug] [--web|-w] [--draft|-d] [--auto|-a] [--model MODEL_NAME] [--title|-t \"TITLE\"] [--body|-b \"BODY\"] [--base BASE_BRANCH]"
        return 1
        ;;
      *)
        # Store positional arguments for later processing
        positional_args+=("$1")
        shift
        ;;
    esac
  done

  # Get current branch name
  head=$(git symbolic-ref --short HEAD)

  if [ "$debug" = true ]; then
    echo "Debug: Current branch is $head"
  fi

  # Detect default branch (main or master) if base is not specified
  if [ -z "$base" ]; then
    # Check if main branch exists
    if git show-ref --verify --quiet refs/heads/main; then
      base="main"
    # Check if master branch exists
    elif git show-ref --verify --quiet refs/heads/master; then
      base="master"
    else
      echo "❌ Error: Could not detect default branch (main or master)."
      echo "Please specify a base branch with --base."
      return 1
    fi

    if [ "$debug" = true ]; then
      echo "Debug: Detected default branch: $base"
    fi
  fi

  # Safety check: Prevent creating PRs from master/main branch
  if [[ "$head" == "master" || "$head" == "main" ]]; then
    echo "❌ Error: Cannot create a PR from the $head branch."
    echo "Please checkout a feature branch first."
    return 1
  fi

  # Safety check: Prevent creating PRs with the same source and target branch
  if [[ "$head" == "$base" ]]; then
    echo "❌ Error: Source branch ($head) and target branch ($base) cannot be the same."
    echo "Please specify a different base branch with --base."
    return 1
  fi

  # If auto flag is set, use ollama to generate a title
  if [ "$auto" = true ]; then
    echo "✓ Generating PR title using model: $model"

    # Create a temporary file for the git diff
    local diff_file=$(mktemp)

    # Find the commit where the branch diverged from base
    local merge_base=$(git merge-base "$base" "$head")

    if [ "$debug" = true ]; then
      echo "Debug: Merge base commit is $merge_base"
    fi

    # Get the diff between the merge base and the current HEAD
    git --no-pager diff "$merge_base" HEAD > "$diff_file"

    # Check if there are changes
    if [ ! -s "$diff_file" ]; then
      echo "❌ No changes detected between $base and $head."
      rm "$diff_file"
      return 1
    fi

    # Create the prompt
    local prompt="
    Create a title for a pull request based on the following git diff:

    Here are the changes:
    $(cat "$diff_file")

    IMPORTANT: Follow these instructions when creating the PR title
    - Your response should be ONLY the PR title without any additional explanations
    - Keep the title concise and descriptive, ideally less than 70 characters
    - Do not use single or double quotes for the title, simply output the title
    - Focus on what the changes accomplish, not the technical details
    - Do not use prefixes like 'PR:', 'Pull Request:', etc.
    - Do not use any trailing punctuation
    "

    # Print the prompt if debug is enabled
    if [ "$debug" = true ]; then
      echo "Debug: Sending the following prompt to $model:"
      echo "--------- PROMPT START ---------"
      echo "$prompt"
      echo "---------- PROMPT END ----------"
    fi

    title=$(ollama run "$model" "$prompt" 2>/dev/null)

    # Cleanup temporary file
    rm "$diff_file"

    echo "✓ PR title generated: $title"
  # If no title is provided, use the first commit message in the branch
  elif [ -z "$title" ]; then
    echo "✓ No title provided. Using first commit message as PR title..."

    # Find the commit where the branch diverged from base
    local merge_base=$(git merge-base "$base" "$head")

    if [ "$debug" = true ]; then
      echo "Debug: Merge base commit is $merge_base"
    fi

    # Get the first commit after the merge base
    local first_commit=$(git log --reverse --format="%H" "$merge_base..$head" | head -n 1)

    if [ -z "$first_commit" ]; then
      echo "❌ No commits found in this branch. Cannot create PR."
      return 1
    fi

    if [ "$debug" = true ]; then
      echo "Debug: First commit in branch is $first_commit"
    fi

    # Get the commit message of the first commit
    title=$(git log -1 --pretty=%s "$first_commit")
    echo "✓ Using commit message as title: $title"
  fi

  # Build the gh pr create command
  local cmd="gh pr create --base \"$base\" --head \"$head\" --title \"$title\""

  # Add body if provided
  if [ -n "$body" ]; then
    cmd="$cmd --body \"$body\""
  fi

  # Add web flag if specified
  if [ "$web" = true ]; then
    cmd="$cmd --web"
  fi

  # Add draft flag if specified
  if [ "$draft" = true ]; then
    cmd="$cmd --draft"
  fi

  if [ "$debug" = true ]; then
    echo "Debug: Running command: $cmd"
  fi

  echo "✓ Creating pull request..."
  echo "---------------------------------"

  # Execute the command
  eval "$cmd"

  local result=$?
  if [ $result -eq 0 ]; then
    echo "---------------------------------"
    echo "✅ Pull request created successfully!"
  else
    echo "---------------------------------"
    echo "❌ Failed to create pull request."
  fi

  return $result
}