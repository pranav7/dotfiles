#!/bin/false

print_header "setting up macOS"

# Install oh-my-zsh
echo "Setting up oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh already installed"
fi

# Now create .zshrc symlink after oh-my-zsh installation to restore our custom config
echo "Restoring custom .zshrc configuration"
if [[ -L "$HOME/.zshrc" ]]; then
    echo ".zshrc symlink already exists"
elif [[ -f "$HOME/.zshrc" ]]; then
    echo "Backing up existing .zshrc"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    ln -s "$HOME/dotfiles/shell/zsh/.zshrc" "$HOME/.zshrc"
    echo "Created .zshrc symlink"
else
    ln -s "$HOME/dotfiles/shell/zsh/.zshrc" "$HOME/.zshrc"
    echo "Created .zshrc symlink"
fi

# Install nvm (Node Version Manager)
echo "Setting up nvm"
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    echo "nvm already installed"
fi

# Install fzf (fuzzy finder)
echo "Setting up fzf"
if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
else
    echo "fzf already installed"
fi

# Install z.sh for directory jumping
echo "Setting up z.sh"
if [ ! -d "$HOME/z" ]; then
    echo "Installing z.sh..."
    git clone https://github.com/rupa/z.git "$HOME/z"
else
    echo "z.sh already installed"
fi

# Install packages with Homebrew
echo "Installing packages with Homebrew"
if command -v brew &> /dev/null; then
    if ! command -v neovim &> /dev/null; then
        echo "Installing neovim..."
        brew install neovim
    else
        echo "neovim already installed"
    fi
    
    if ! command -v tmux &> /dev/null; then
        echo "Installing tmux..."
        brew install tmux
    else
        echo "tmux already installed"
    fi
    
    if ! command -v lsd &> /dev/null; then
        echo "Installing lsd..."
        brew install lsd
    else
        echo "lsd already installed"
    fi
    
    if ! brew list zsh-syntax-highlighting &> /dev/null 2>&1; then
        echo "Installing zsh-syntax-highlighting..."
        brew install zsh-syntax-highlighting
    else
        echo "zsh-syntax-highlighting already installed"
    fi
else
    echo "Homebrew not found. Please install Homebrew first: https://brew.sh"
fi

# Install Nerd Fonts
echo "Installing Nerd Fonts"
if command -v brew &> /dev/null; then
    # Install CaskaydiaCove Nerd Font directly (no tap needed since fonts migrated to homebrew/cask)
    if ! brew list --cask font-caskaydia-cove-nerd-font &> /dev/null 2>&1; then
        echo "Installing CaskaydiaCove Nerd Font..."
        brew install --cask font-caskaydia-cove-nerd-font
    else
        echo "CaskaydiaCove Nerd Font already installed"
    fi
else
    echo "Homebrew not found. Cannot install Nerd Fonts without Homebrew."
fi

# Enable key repeat system-wide and for specific apps
echo "Enabling key repeat system-wide"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "Enabling VSCode key repeat"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

echo "Enabling Cursor key repeat"
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false

# Ghostty config (macOS specific path)
echo "Creating Ghostty config"
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

