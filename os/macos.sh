#!/bin/false

print_header "setting up macOS"

# Install packages with Homebrew
echo "Installing packages with Homebrew"
if command -v brew &> /dev/null; then
    echo "Installing lsd..."
    brew install lsd
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

