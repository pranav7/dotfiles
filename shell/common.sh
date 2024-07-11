#!/bin/false

source ~/dotfiles/shell/functions.sh
source ~/dotfiles/shell/aliases.sh
source ~/dotfiles/shell/nvm.sh

safe_source ~/dotfiles/shell/local.sh

source $HOME/z/z.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export TERM="xterm-256color"
export BUNDLER_EDITOR=nvim
export EDITOR=nvim
export GIT_EDITOR=nvim
export ZSH=$HOME/.oh-my-zsh

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# eval "$(rbenv init - zsh)"

source $HOME/z/z.sh
# source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

plugins=(
  git
  bundler
  fzf
)
