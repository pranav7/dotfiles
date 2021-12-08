#!/usr/bin/env zsh

# .zprofile is the user-specific initialization file for zsh, and is read
# by both login and interactive shells, unlike .zshrc.

source ~/dotfiles/shell/common.sh
source ~/dotfiles/shell/zsh/functions.zsh
source ~/dotfiles/shell/zsh/prompt.zsh

autoload -Uz compinit promptinit
compinit -i
promptinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' fzf-search-display true

# Config from: https://github.com/Aloxaf/fzf-tab#configure
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
