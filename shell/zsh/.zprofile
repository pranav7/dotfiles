#!/usr/bin/env zsh

# .zprofile is the user-specific initialization file for zsh, and is read
# by both login and interactive shells, unlike .zshrc.

source ~/dotfiles/shell/common.sh
source ~/dotfiles/shell/zsh/functions.zsh
source ~/dotfiles/shell/zsh/prompt.zsh

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/pranavsingh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(/opt/homebrew/bin/brew shellenv)"
