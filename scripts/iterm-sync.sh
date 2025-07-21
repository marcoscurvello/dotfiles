#!/usr/bin/env bash

# Sync iTerm2 preferences
# This script handles backing up and restoring iTerm preferences properly

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# iTerm preferences location
ITERM_PREFS="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
DOTFILES_ITERM="$DOTFILES_DIR/iterm/com.googlecode.iterm2.plist"

# Function to backup current iTerm settings
backup_iterm() {
    log_step "Backing up iTerm2 preferences..."
    
    if [[ -f "$ITERM_PREFS" ]]; then
        # Copy the current preferences to dotfiles
        cp "$ITERM_PREFS" "$DOTFILES_ITERM"
        log_success "iTerm2 preferences backed up"
        
        # Convert to XML for better git diffs (optional)
        if command_exists plutil; then
            plutil -convert xml1 "$DOTFILES_ITERM"
            log_info "Converted to XML format for better version control"
        fi
    else
        log_warning "iTerm2 preferences file not found"
    fi
}

# Function to restore iTerm settings
restore_iterm() {
    log_step "Restoring iTerm2 preferences..."
    
    if [[ -f "$DOTFILES_ITERM" ]]; then
        # Quit iTerm2 if running
        if pgrep -x "iTerm2" > /dev/null; then
            log_info "iTerm2 is running. Please quit iTerm2 and run this script again."
            log_info "Or run: osascript -e 'quit app \"iTerm2\"'"
            return 1
        fi
        
        # Backup current preferences
        if [[ -f "$ITERM_PREFS" ]]; then
            local backup_file="$ITERM_PREFS.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$ITERM_PREFS" "$backup_file"
            log_info "Current preferences backed up to: $backup_file"
        fi
        
        # Copy preferences from dotfiles
        cp "$DOTFILES_ITERM" "$ITERM_PREFS"
        
        # Convert to binary format
        plutil -convert binary1 "$ITERM_PREFS"
        
        # Set custom folder path
        defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm"
        defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
        
        # Clear preferences cache
        defaults read com.googlecode.iterm2 > /dev/null 2>&1
        killall cfprefsd 2>/dev/null || true
        
        log_success "iTerm2 preferences restored"
        log_info "Start iTerm2 to see the changes"
    else
        log_error "No iTerm2 preferences found in dotfiles"
    fi
}

# Main menu
main() {
    if [[ "$1" == "backup" ]]; then
        backup_iterm
    elif [[ "$1" == "restore" ]]; then
        restore_iterm
    else
        echo "Usage: $0 [backup|restore]"
        echo ""
        echo "Commands:"
        echo "  backup   - Save current iTerm2 preferences to dotfiles"
        echo "  restore  - Restore iTerm2 preferences from dotfiles"
        echo ""
        echo "Note: iTerm2 must be closed when restoring preferences"
    fi
}

main "$@"