#!/usr/bin/env bash

# Fix iTerm2 configuration issues
# This script properly restores iTerm settings and fixes the custom folder loading

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔧 Fixing iTerm2 Configuration..."
echo "================================"

# Step 1: Check if iTerm is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "❌ iTerm2 is currently running!"
    echo "Please quit iTerm2 completely and run this script again."
    echo ""
    echo "You can quit iTerm2 with: osascript -e 'quit app \"iTerm2\"'"
    exit 1
fi

# Step 2: Backup current preferences
BACKUP_DIR="$HOME/.dotfiles_backup_iterm_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [[ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]]; then
    cp "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$BACKUP_DIR/"
    echo "✓ Current preferences backed up to: $BACKUP_DIR"
fi

# Step 3: Remove current preferences and cache
echo "🧹 Cleaning current preferences..."
rm -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
rm -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist.lockfile"
defaults delete com.googlecode.iterm2 2>/dev/null || true

# Clear preferences cache
killall cfprefsd 2>/dev/null || true

# Step 4: Copy clean preferences from dotfiles
echo "📦 Restoring preferences from dotfiles..."
cp "$DOTFILES_DIR/iterm/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/"

# Step 5: Convert to binary format (required by macOS)
plutil -convert binary1 "$HOME/Library/Preferences/com.googlecode.iterm2.plist"

# Step 6: Set the custom folder path
echo "🔗 Setting custom preferences folder..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0

# Step 7: Import the state file if it exists
if [[ -f "$DOTFILES_DIR/iterm/iterm2_state.itermexport" ]]; then
    echo "📥 Found iTerm2 export file - will import on next launch"
    echo ""
    echo "After starting iTerm2:"
    echo "1. Go to iTerm2 → Settings → General → Preferences"
    echo "2. Click 'Import All Settings and Data'"
    echo "3. Select: $DOTFILES_DIR/iterm/iterm2_state.itermexport"
    echo "4. Restart iTerm2 again"
fi

echo ""
echo "✅ iTerm2 configuration fixed!"
echo ""
echo "Next steps:"
echo "1. Start iTerm2"
echo "2. Check Settings → General → Preferences"
echo "3. 'Load preferences from custom folder' should be checked"
echo "4. Path should be: $DOTFILES_DIR/iterm"
echo ""
echo "If settings still don't look right:"
echo "- Import from: $DOTFILES_DIR/iterm/iterm2_state.itermexport"
echo "- Or manually set the custom folder path in preferences"

# Step 8: Create a marker file to track this fix
echo "$(date)" > "$DOTFILES_DIR/iterm/.last_fix"