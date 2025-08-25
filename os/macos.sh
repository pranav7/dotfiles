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
    echo "Installing lsd..."
    brew install lsd
    echo "Installing zsh-syntax-highlighting..."
    brew install zsh-syntax-highlighting
else
    echo "Homebrew not found. Please install Homebrew first: https://brew.sh"
fi

# Enable VSCode key repeat
echo "Enabling VSCode key repeat"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Ghostty config (macOS specific path)
echo "Creating Ghostty config"
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

