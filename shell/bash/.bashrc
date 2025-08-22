# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Source all dotfiles shell configurations
source ~/dotfiles/shell/functions.sh
source ~/dotfiles/shell/aliases.sh
source ~/dotfiles/shell/gh.sh

# Source bash-specific functions
source ~/dotfiles/shell/bash/functions.bash

# Source bash-specific common configuration
source ~/dotfiles/shell/bash/common.bash

# Source local shell configuration if it exists
safe_source ~/dotfiles/shell/local.sh

# Set Homebrew prefix based on architecture
if [[ $(uname -m) == 'arm64' ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
else
  export HOMEBREW_PREFIX="/usr/local"
fi

# Initialize starship prompt
eval "$(starship init bash)"

export NVM_DIR="$HOME/.nvm"
# Enable hash table for command lookup (fixes NVM hash warning)
set -h 2>/dev/null || true
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init bash)"

source ~/dotfiles/shell/bash/git-aliases.sh
