#!/bin/bash
# Fix for Shift+Enter in Claude Code with tmux + Alacritty on macOS

echo "Setting up Shift+Enter for Claude Code in tmux + Alacritty..."
echo ""

# Test if we're in tmux
if [ -n "$TMUX" ]; then
    echo "✓ Running inside tmux session"
    
    # Enable extended-keys in current tmux session
    tmux set-option -s extended-keys always
    tmux set-option -sa terminal-features '*:extkeys'
    
    # Remove old binding and add correct one for Shift+Enter
    tmux unbind-key -n S-Enter 2>/dev/null
    tmux unbind-key -n S-Return 2>/dev/null
    
    # Bind Shift+Return to pass through the CSI u sequence
    tmux bind-key -n S-Return send-keys Escape "[13;2u"
    
    echo "✓ Tmux configuration updated for current session"
    echo ""
else
    echo "⚠ Not in tmux. Please run this script inside a tmux session."
    echo ""
fi

echo "Configuration needed in ~/.tmux.conf:"
echo "----------------------------------------"
cat << 'EOF'
# Enable extended keys
set-option -g extended-keys on
set-option -sa terminal-features ',*:extkeys'

# Pass through Shift+Enter for Claude Code
bind-key -n S-Return send-keys Escape "[13;2u"

# macOS clipboard integration
set -g set-clipboard on
set -g allow-passthrough on
set -ga terminal-features ',alacritty*:clipboard'
EOF

echo ""
echo "Configuration needed in alacritty.toml:"
echo "----------------------------------------"
echo '  { key = "Return", mods = "Shift", chars = "\x1b[13;2u" },'
echo ""
echo "To test if it's working:"
echo "1. Run: cat -v"
echo "2. Press Shift+Enter"
echo "3. You should see: ^[[13;2u"
echo ""
echo "If using Claude Code, Shift+Enter should now insert a newline without submitting."