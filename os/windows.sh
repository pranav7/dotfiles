#!/bin/false

print_header "setting up Windows"

# Ghostty config (Windows path) 
if command -v ghostty.exe >/dev/null 2>&1 || command -v ghostty >/dev/null 2>&1; then
  echo "Creating Ghostty config"
  mkdir -p "$APPDATA/ghostty"
  ln -sf "$HOME/dotfiles/ghostty/config" "$APPDATA/ghostty/config" 2>/dev/null || cp "$HOME/dotfiles/ghostty/config" "$APPDATA/ghostty/config"
else
  echo "Ghostty not found, skipping config"
fi