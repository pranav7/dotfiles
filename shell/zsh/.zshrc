#!/usr/bin/env zsh
# .zshrc is only read by interactive (non-login) shells, but we copy the config
# from there to make sure our options are always loaded.

# ASDF setup
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# Platform-specific PATH additions
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific paths
    export PATH="/opt/homebrew/Caskroom/clickhouse/latest/bin:$PATH"
    
    # Bun setup for macOS
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    
    # Deno setup for macOS
    [ -f "$HOME/.deno/env" ] && source "$HOME/.deno/env"
    
    # Claude alias for macOS
    [ -f "$HOME/.claude/local/claude" ] && alias claude="$HOME/.claude/local/claude"
fi

# Common PATH additions
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# NVM setup - cross-platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - manual nvm installation
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - Arch package installation
    if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
        source /usr/share/nvm/init-nvm.sh
    elif [ -f "/usr/share/nvm/nvm.sh" ]; then
        export NVM_DIR="/usr/share/nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    fi
fi

# Load local environment if it exists
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# Load zprofile
[ -f ~/.zprofile ] && source ~/.zprofile

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
