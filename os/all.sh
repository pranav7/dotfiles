#!/bin/false

print_header "creating symlinks"

### Shell configuration
echo "Setting up shell configuration"
symlink_to_home ~/dotfiles/shell/zsh/.zprofile
symlink_to_home ~/dotfiles/shell/zsh/.zshrc

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

print_header "setting up applications"

# Neovim config (cross-platform)
echo "Creating Neovim config symlink"
mkdir -p "$HOME/.config"
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"