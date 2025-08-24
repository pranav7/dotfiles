#!/usr/bin/env zsh

# .zprofile is the user-specific initialization file for zsh, and is read
# by both login and interactive shells, unlike .zshrc.

autoload -Uz compinit
compinit

source ~/dotfiles/shell/common.sh
# source ~/dotfiles/shell/zsh/prompt.zsh  # Disabled - using Starship instead
source ~/dotfiles/shell/zsh/aliases.sh
source ~/dotfiles/shell/zsh/prompt.zsh

zstyle :compinstallfilename '/Users/pranavsingh/.zshrc'

eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.orbstack/shell/init.zsh 2>/dev/null || :
