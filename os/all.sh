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

# Neovim LazyVim config (cross-platform)
echo "Setting up Neovim with LazyVim"
mkdir -p "$HOME/.config"

# Backup existing Neovim config if it exists and isn't a symlink
if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
    echo "Backing up existing Neovim config"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create symlink to LazyVim config
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
echo "LazyVim config linked successfully"

# Create backup directories for Neovim state/cache if they don't exist
mkdir -p "$HOME/.local/share/nvim"
mkdir -p "$HOME/.local/state/nvim"
mkdir -p "$HOME/.cache/nvim"

# Cursor config (cross-platform)
echo "Creating Cursor config symlinks"
mkdir -p "$HOME/Library/Application Support/Cursor/User"
ln -sf "$HOME/dotfiles/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
ln -sf "$HOME/dotfiles/cursor/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"
echo "Cursor config linked successfully"

echo "Creating Ghostty config"
# Linux Ghostty config location
if [[ -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config/ghostty"
    ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
    echo "Ghostty config linked successfully"
else
    echo "Warning: ~/.config directory not found, Ghostty config not linked"
fi
