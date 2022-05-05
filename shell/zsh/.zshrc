#!/usr/bin/env zsh

# .zshrc is only read by interactive (non-login) shells, but we copy the config
# from there to make sure our options are always loaded.

source ~/.zprofile

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
