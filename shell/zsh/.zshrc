#!/usr/bin/env zsh

# .zshrc is only read by interactive (non-login) shells, but we copy the config
# from there to make sure our options are always loaded.

source ~/.zprofile

export PATH="/opt/homebrew/Caskroom/clickhouse/latest/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/dotfiles/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


. "$HOME/.local/bin/env"

# bun completions
[ -s "/Users/pranav/.bun/_bun" ] && source "/Users/pranav/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "/Users/pranav/.deno/env"