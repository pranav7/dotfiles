#!/usr/bin/env zsh

# .zprofile is the user-specific initialization file for zsh, and is read
# by both login and interactive shells, unlike .zshrc.

source ~/dotfiles/shell/common.sh
source ~/dotfiles/shell/zsh/prompt.zsh

# The following lines were added by compinstall
zstyle :compinstallfilename '/Users/pranavsingh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
