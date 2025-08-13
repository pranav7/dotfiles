#!/bin/false

function commit() {
  local model="llama3.2"
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
      --push|--p)
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
  git --no-pager diff --cached > "$diff_file"

  # Check if there are changes to commit
  if [ ! -s "$diff_file" ]; then
    echo "⚠️ No changes to commit."
    rm "$diff_file"
    return 1
  fi

  # If no commit message was provided, generate one using ollama
  if [ -z "$commit_msg" ]; then
    echo "✓ Generating commit message using model: $model"

    # Create the prompt
    local prompt="
    You are a senior engineer writing Git commit messages that are clear, concise, and useful for code review and changelog generation.
    Follow the Conventional Commits 1.0.0 specification strictly.
    Always use the imperative mood and keep the first line ≤72 characters.
    Output only the commit message, nothing else.

    Given the full staged diff, write a single commit message that:
    - Uses Conventional Commits format: <type>(optional scope): <description>.
    - Chooses the best type from: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert. Use ! or a BREAKING CHANGE footer for breaking changes.
    - First line is an imperative, concise summary of all changes across files (≤72 chars).
    - Add a blank line, then a short body explaining rationale, context, and notable tradeoffs in 2–5 lines; prefer bullets for multiple points.
    - Reference issues/PRs in footers when present (e.g., Closes #123).
    - Do not include code blocks or quotes; output only the commit message.

    Heuristics for type/scope:
    - feat: new user-visible behavior, API, CLI, config, or flag.
    - fix: bug fix or regression repair.
    - refactor: structural change without behavior change.
    - perf: measurable performance improvement.
    - docs/style/test/build/ci/chore: as commonly defined.
    - Use scope from the dominant directory or component in the diff (e.g., api, auth, ci, build, ui).

    Multi-file diffs:
    - Summarize the primary intent across all files, not just the first hunk.
    - If multiple unrelated intents are present, prioritize the most impactful and mention the rest in the body.

    Style rules:
    - Imperative mood: “add”, “fix”, “update”, “remove”, “refactor”, “rename”.
    - No trailing period on the subject line. Keep ≤72 chars.
    - Body lines ≤100 chars; use concise bullets when listing.

    Input:
    $(cat "$diff_file")

    Output format:
    <type>(optional-scope): <concise subject ≤72 chars>
    - Why and what changed at a high level.
    - Key details, constraints, or side-effects.
    - Note tests/docs/build updates if relevant.

    Example outputs:
    feat(auth): add OAuth2 login with Google
    - Implement OAuth2 flow and token refresh.
    - Persist sessions with secure cookies.
    - Refs: #482

    fix(worker): resolve memory leak in connection pool
    - Close idle connections and add timeout.
    - Add regression test for idle cleanup.

    refactor(api): extract pagination helper
    - Centralize page/limit parsing and validation.
    - Replace duplicated logic across 4 handlers.
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