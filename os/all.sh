#!/bin/false

## Symlinks

print_header "creating symlinks"

### git

# symlink_to_home ~/dotfiles/git/.gitconfig
# symlink_to_home ~/dotfiles/git/.gitignore_global

### shell

# symlink_to_home ~/dotfiles/shell/.inputrc

#### bash

# symlink_to_home ~/dotfiles/shell/bash/.bash_profile
# symlink_to_home ~/dotfiles/shell/bash/.bashrc

#### zsh

symlink_to_home ~/dotfiles/shell/zsh/.zprofile
symlink_to_home ~/dotfiles/shell/zsh/.zshrc

### ruby

# symlink_to_home ~/dotfiles/ruby/.ruby-version
# symlink_to_home ~/dotfiles/ruby/.rubocop.yml

### editors

# symlink_to_home ~/dotfiles/editor/.editorconfig
symlink_to_home ~/dotfiles/vim/.vimrc

### tmux

symlink_to_home ~/dotfiles/tmux/.tmux.conf
make_executable ~/dotfiles/bin/tat

### other setup

echo "Enabling VSCode to key presses"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
