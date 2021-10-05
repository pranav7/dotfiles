#!/bin/false

source ~/dotfiles/shell/functions.sh
source ~/dotfiles/shell/aliases.sh
source ~/dotfiles/shell/nvm.sh

safe_source ~/dotfiles/shell/intercom.sh

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
source $HOME/z/z.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Path to your oh-my-zsh installation.
# export TERM="xterm-256color"
export TERM="xterm-new"
export ZSH="/Users/pranavsingh/.oh-my-zsh"
export BUNDLER_EDITOR=nvim

# ZSH_THEME="robbyrussell"

# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'

plugins=(rails git)