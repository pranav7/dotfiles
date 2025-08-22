#!/bin/bash

print_header "setting up Linux (Arch Linux)"

# Install packages if we're on Arch Linux
if command -v pacman >/dev/null 2>&1; then
    print_header "Installing packages with pacman"
    
    # Check if running as root for package installation
    if [[ $EUID -eq 0 ]]; then
        echo "Installing essential packages..."
        pacman -S --noconfirm \
            git \
            vim \
            tmux \
            zsh \
            alacritty \
            fzf \
            ripgrep \
            fd \
            bat \
            exa \
            htop \
            tree
    else
        echo "Note: Run with sudo to install packages automatically"
        echo "Or install manually: sudo pacman -S git vim tmux zsh alacritty fzf ripgrep fd bat exa htop tree"
    fi
else
    echo "Note: Not on Arch Linux, please install required packages manually"
fi

# Create necessary directories
print_header "Creating necessary directories"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Make sure the bin directory scripts are executable
print_header "Making bin scripts executable"
for script in "$HOME/dotfiles/bin"/*; do
    if [[ -f "$script" ]]; then
        chmod +x "$script"
        echo "Made executable: $(basename "$script")"
    fi
done

# Ghostty config (Linux path)
if command -v ghostty >/dev/null 2>&1; then
  echo "Creating Ghostty config"
  mkdir -p "$HOME/.config/ghostty"
  ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
else
  echo "Ghostty not found, skipping config"
fi

print_header "Linux setup complete!"