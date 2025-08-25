#!/bin/bash

print_header "creating symlinks"

### Shell configuration
echo "Setting up shell configuration"
symlink_to_home ~/dotfiles/shell/zsh/.zprofile

# Note: .zshrc symlink will be created after oh-my-zsh installation to avoid conflicts

### Starship prompt
echo "Setting up starship prompt"
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    echo "Adding ~/.local/bin to PATH if not already present"
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zprofile"
    fi
else
    echo "Starship already installed"
fi
mkdir -p "$HOME/.config"
ln -sf "$HOME/dotfiles/starship/starship.toml" "$HOME/.config/starship.toml"
echo "Starship config linked successfully"

### Editor configuration  
echo "Setting up editor configuration"
symlink_to_home ~/dotfiles/vim/.vimrc

### Terminal multiplexer
echo "Setting up tmux"
symlink_to_home ~/dotfiles/tmux/.tmux.conf
make_executable ~/dotfiles/bin/tat

### Scripts
echo "Making scripts executable"
make_executable ~/dotfiles/bin/list-functions
make_executable ~/dotfiles/bin/worktree
make_executable ~/dotfiles/bin/wt

### applications
# Note: VSCode key press settings are platform-specific
# For Linux, this would need to be configured differently

print_header "setting up applications"

# Neovim config (cross-platform)
echo "Creating Neovim config symlink"
mkdir -p "$HOME/.config"
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

echo "Creating Ghostty config"
# Linux Ghostty config location
if [[ -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config/ghostty"
    ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
    echo "Ghostty config linked successfully"
else
    echo "Warning: ~/.config directory not found, Ghostty config not linked"
fi
