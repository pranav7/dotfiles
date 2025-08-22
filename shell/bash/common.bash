#!/bin/bash

# Common environment variables and configurations for bash
export DISABLE_SPRING=true
export TERM="xterm-256color"
export BUNDLER_EDITOR=nvim
export EDITOR=nvim
export GIT_EDITOR=nvim
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'

# Source fzf if available
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source z (directory jumping) if available
[ -f $HOME/z/z.sh ] && source $HOME/z/z.sh

# Set Homebrew prefix based on architecture
if [[ $(uname -m) == 'arm64' ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
else
  export HOMEBREW_PREFIX="/usr/local"
fi

