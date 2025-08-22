#!/bin/false

print_header "setting up macOS"

# Enable VSCode key repeat
echo "Enabling VSCode key repeat"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Ghostty config (macOS specific path)
echo "Creating Ghostty config"
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

