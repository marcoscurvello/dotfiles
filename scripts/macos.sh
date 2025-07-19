#!/usr/bin/env bash

# Configure macOS system preferences

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

# Close System Preferences to prevent conflicts
close_system_preferences() {
    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
}

# Configure Dock
configure_dock() {
    log_step "Configuring Dock preferences..."
    
    # Auto-hide dock
    defaults write com.apple.dock autohide -bool true
    log_info "✓ Auto-hide dock enabled"
    
    # Remove auto-hide delay
    defaults write com.apple.dock autohide-delay -float 0
    log_info "✓ Auto-hide delay removed"
    
    # Speed up animation
    defaults write com.apple.dock autohide-time-modifier -float 0.5
    log_info "✓ Animation speed increased"
    
    # Minimize windows using scale effect
    defaults write com.apple.dock mineffect -string "scale"
    log_info "✓ Minimize effect set to scale"
    
    # Don't animate opening applications
    defaults write com.apple.dock launchanim -bool false
    log_info "✓ Launch animation disabled"
    
    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true
    log_info "✓ Hidden app icons made translucent"
    
    log_success "Dock configuration complete"
}

# Configure Finder
configure_finder() {
    log_step "Configuring Finder preferences..."
    
    # Show all files (including hidden)
    defaults write com.apple.finder AppleShowAllFiles -bool true
    log_info "✓ Show all files enabled"
    
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    log_info "✓ Path bar enabled"
    
    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    log_info "✓ Status bar enabled"
    
    # Use list view by default
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    log_info "✓ Default view set to list"
    
    # Show file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    log_info "✓ File extensions shown"
    
    # Disable warning when changing file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    log_info "✓ Extension change warning disabled"
    
    # Keep folders on top when sorting
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    log_info "✓ Folders kept on top"
    
    # Search current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    log_info "✓ Search scope set to current folder"
    
    log_success "Finder configuration complete"
}

# Configure Screenshots
configure_screenshots() {
    log_step "Configuring screenshot settings..."
    
    # Create screenshots directory
    local screenshot_dir="$HOME/Desktop/Screenshots"
    if [[ ! -d "$screenshot_dir" ]]; then
        mkdir -p "$screenshot_dir"
        log_info "✓ Created screenshot directory"
    fi
    
    # Set screenshot location
    defaults write com.apple.screencapture location "$screenshot_dir"
    log_info "✓ Screenshot location set to $screenshot_dir"
    
    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true
    log_info "✓ Screenshot shadows disabled"
    
    # Use PNG format
    defaults write com.apple.screencapture type -string "png"
    log_info "✓ Screenshot format set to PNG"
    
    log_success "Screenshot configuration complete"
}

# Configure Input Devices
configure_input() {
    log_step "Configuring input devices..."
    
    # Enable tap to click for trackpad
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    log_info "✓ Tap to click enabled"
    
    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    log_info "✓ Full keyboard access enabled"
    
    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    log_info "✓ Key repeat enabled"
    
    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    log_info "✓ Fast key repeat configured"
    
    log_success "Input device configuration complete"
}

# Configure Other Settings
configure_other() {
    log_step "Configuring other settings..."
    
    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    log_info "✓ Save panels expanded by default"
    
    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    log_info "✓ Print panels expanded by default"
    
    # Save to disk (not to iCloud) by default
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    log_info "✓ Default save location set to disk"
    
    # Disable automatic capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    log_info "✓ Automatic capitalization disabled"
    
    # Disable smart dashes
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    log_info "✓ Smart dashes disabled"
    
    # Disable automatic period substitution
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    log_info "✓ Automatic period substitution disabled"
    
    # Disable smart quotes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    log_info "✓ Smart quotes disabled"
    
    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    log_info "✓ Auto-correct disabled"
    
    log_success "Other settings configured"
}

# Install fonts
install_fonts() {
    log_step "Installing fonts..."
    
    local font_dir="$DOTFILES_DIR/fonts"
    local dest_dir="$HOME/Library/Fonts"
    
    if [[ ! -d "$font_dir" ]]; then
        log_warning "Font directory not found at: $font_dir"
        log_info "Skipping font installation"
        return 0
    fi
    
    # Create fonts directory
    mkdir -p "$dest_dir"
    
    # Count fonts before
    local before_count=$(find "$dest_dir" -name "*.ttf" -o -name "*.otf" 2>/dev/null | wc -l | tr -d ' ')
    
    # Install fonts
    local installed=0
    
    # MesloLGS NF fonts (for Powerlevel10k)
    if [[ -d "$font_dir/MesloGSF" ]]; then
        log_info "Installing MesloLGS NF fonts..."
        find "$font_dir/MesloGSF" -name "*.ttf" -exec cp {} "$dest_dir/" \; 2>/dev/null && ((installed++)) || true
    fi
    
    # Hack Nerd Fonts
    if [[ -d "$font_dir/hacknerd" ]]; then
        log_info "Installing Hack Nerd fonts..."
        find "$font_dir/hacknerd" -name "*.ttf" -exec cp {} "$dest_dir/" \; 2>/dev/null && ((installed++)) || true
    fi
    
    # Powerline fonts
    log_info "Installing Powerline fonts..."
    find "$font_dir" -name "*Powerline*.otf" -o -name "*Powerline*.ttf" -exec cp {} "$dest_dir/" \; 2>/dev/null && ((installed++)) || true
    
    # Inconsolata fonts
    log_info "Installing Inconsolata fonts..."
    find "$font_dir" -name "Inconsolata*.otf" -exec cp {} "$dest_dir/" \; 2>/dev/null && ((installed++)) || true
    
    # Count fonts after
    local after_count=$(find "$dest_dir" -name "*.ttf" -o -name "*.otf" 2>/dev/null | wc -l | tr -d ' ')
    local new_fonts=$((after_count - before_count))
    
    if [[ $new_fonts -gt 0 ]]; then
        log_success "$new_fonts fonts installed"
        log_info "You may need to restart applications to see new fonts"
    else
        log_info "No new fonts installed (may already be present)"
    fi
}

# Restart affected applications
restart_apps() {
    log_step "Restarting affected applications..."
    
    # Restart Dock
    if killall Dock 2>/dev/null; then
        log_info "✓ Dock restarted"
    fi
    
    # Restart Finder
    if killall Finder 2>/dev/null; then
        log_info "✓ Finder restarted"
    fi
    
    # Restart SystemUIServer (for menu bar changes)
    if killall SystemUIServer 2>/dev/null; then
        log_info "✓ SystemUIServer restarted"
    fi
    
    log_success "Applications restarted"
}

# Main function
main() {
    show_header "macOS System Configuration"
    
    # Close System Preferences
    close_system_preferences
    
    # Configure various settings
    configure_dock
    configure_finder
    configure_screenshots
    configure_input
    configure_other
    
    # Install fonts
    install_fonts
    
    # Restart affected apps
    restart_apps
    
    show_footer "macOS Configuration Complete"
    
    # Notes
    echo ""
    log_info "${BOLD}Changes applied:${NC}"
    log_info "• Dock auto-hides with no delay"
    log_info "• Finder shows hidden files and status bars"
    log_info "• Screenshots save to ~/Desktop/Screenshots"
    log_info "• Keyboard repeat rate increased"
    log_info "• Various text substitutions disabled"
    log_info ""
    log_info "Some changes may require logging out and back in to take full effect"
}

# Run main function
main "$@"