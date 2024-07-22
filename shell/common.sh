#!/bin/false

source ~/dotfiles/shell/functions.sh
source ~/dotfiles/shell/aliases.sh
source ~/dotfiles/shell/nvm.sh

safe_source ~/dotfiles/shell/local.sh

export DISABLE_SPRING=true
export TERM="xterm-256color"
export BUNDLER_EDITOR=vim
export EDITOR=vim
export GIT_EDITOR=vim
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="af-magic"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh
source $HOME/z/z.sh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

plugins=(
  git
  bundler
  fzf
  asdf
)
