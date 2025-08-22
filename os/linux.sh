#!/bin/false

print_header "setting up Linux"

# Ghostty config (Linux path)
if command -v ghostty >/dev/null 2>&1; then
  echo "Creating Ghostty config"
  mkdir -p "$HOME/.config/ghostty"
  ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
else
  echo "Ghostty not found, skipping config"
fi