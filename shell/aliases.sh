#!/bin/false

alias tmuxconf="vim ~/.tmux.conf"
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias srczsh="source ~/.zshrc"
alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias redis_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias gitlg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias lsf="find $(pwd)"
alias tmux="TERM=xterm-256color tmux"
alias psf="ps aux | fzf-tmux"
alias gcomp="git compare"
alias userver="script/update && script/server"
alias workspace="hammer workspace"
alias main="git checkout main"
alias prettyjson='python -m json.tool'
alias assume-role='function(){eval $(hammer assume-role $@);}'
alias be='bundle exec'
alias vim='nvim'
