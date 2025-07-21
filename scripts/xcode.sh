#!/usr/bin/env bash

# Configure Xcode themes, snippets, and settings

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

# Check for Xcode Command Line Tools
check_xcode_tools() {
    log_step "Checking Xcode Command Line Tools..."
    
    if are_xcode_tools_installed; then
        log_success "Xcode Command Line Tools are installed"
        return 0
    else
        log_warning "Xcode Command Line Tools not found"
        log_info "Installing Xcode Command Line Tools..."
        
        # Trigger installation
        xcode-select --install 2>/dev/null
        
        log_info "Please complete the installation in the popup window"
        log_info "Then run this script again"
        return 1
    fi
}

# Backup and merge Xcode settings
backup_and_merge_xcode_settings() {
    log_step "Handling Xcode settings backup and merge..."
    
    local xcode_userdata="$HOME/Library/Developer/Xcode/UserData"
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)/xcode"
    local dotfiles_xcode="$DOTFILES_DIR/xcode"
    
    # Ensure Xcode UserData directory exists
    if [[ ! -d "$xcode_userdata" ]]; then
        log_info "Creating Xcode UserData directory..."
        mkdir -p "$xcode_userdata"
        log_success "Created $xcode_userdata"
    fi
    
    # Directories to handle
    local xcode_dirs=("CodeSnippets" "KeyBindings" "FontAndColorThemes")
    
    for dir in "${xcode_dirs[@]}"; do
        local src_dir="$xcode_userdata/$dir"
        local dotfiles_dir="$dotfiles_xcode/$dir"
        
        # Skip if source doesn't exist
        if [[ ! -d "$src_dir" ]]; then
            log_info "$dir directory doesn't exist, skipping..."
            continue
        fi
        
        # Check if it's already a symlink (already configured)
        if [[ -L "$src_dir" ]]; then
            log_info "✓ $dir is already symlinked"
            continue
        fi
        
        # Check if we have existing files to merge
        if [[ -d "$src_dir" ]] && [[ "$(ls -A "$src_dir" 2>/dev/null)" ]]; then
            log_info "Found existing $dir, backing up and merging..."
            
            # Create backup
            mkdir -p "$backup_dir"
            cp -r "$src_dir" "$backup_dir/"
            log_info "✓ Backed up to $backup_dir/$dir"
            
            # Merge items (copy local files that don't exist in dotfiles)
            if [[ -d "$dotfiles_dir" ]]; then
                for file in "$src_dir"/*; do
                    if [[ -f "$file" ]]; then
                        local basename=$(basename "$file")
                        local dotfile="$dotfiles_dir/$basename"
                        
                        if [[ ! -f "$dotfile" ]]; then
                            log_info "Preserving local file: $basename"
                            cp "$file" "$dotfile"
                        fi
                    fi
                done
            fi
            
            # Remove the original directory (will be replaced by symlink)
            rm -rf "$src_dir"
            log_info "✓ Removed original $dir directory"
        fi
    done
    
    # Handle Xcode preferences (backup only, no symlink)
    local xcode_prefs="$HOME/Library/Preferences/com.apple.dt.Xcode.plist"
    if [[ -f "$xcode_prefs" ]]; then
        log_info "Backing up Xcode preferences..."
        mkdir -p "$backup_dir"
        cp "$xcode_prefs" "$backup_dir/"
        log_info "✓ Backed up Xcode preferences"
    fi
}

# Sync Xcode snippets function
install_xcode_sync_function() {
    log_step "Setting up Xcode sync function..."
    
    local sync_script="$DOTFILES_DIR/zsh/functions/xcode-sync"
    
    if [[ -f "$sync_script" ]]; then
        log_success "xcode-sync function already exists"
        log_info "You can use 'xcode-sync' to sync snippets to git"
    else
        log_warning "xcode-sync function not found"
        log_info "Run './dotfiles link' to set up the sync function"
    fi
}

# Configure iTerm2 integration
configure_iterm() {
    log_step "Configuring iTerm2 color schemes..."
    
    local iterm_colors_dir="$DOTFILES_DIR/iterm-colors"
    
    if [[ ! -d "$iterm_colors_dir" ]]; then
        log_info "iTerm color schemes directory not found"
        return 0
    fi
    
    # Check if iTerm2 is installed
    if [[ ! -d "/Applications/iTerm.app" ]]; then
        log_info "iTerm2 not installed, skipping configuration"
        return 0
    fi
    
    log_info "iTerm2 color schemes available in: $iterm_colors_dir"
    log_info "To import color schemes:"
    log_info "1. Open iTerm2 Preferences (⌘,)"
    log_info "2. Go to Profiles → Colors"
    log_info "3. Click 'Color Presets...' → 'Import...'"
    log_info "4. Navigate to $iterm_colors_dir"
    log_info "5. Select the color scheme files to import"
}

# Setup VS Code
setup_vscode() {
    log_step "Checking VS Code setup..."
    
    # Check if VS Code settings are symlinked
    local vscode_settings="$HOME/Library/Application Support/Code/User/settings.json"
    
    if [[ -L "$vscode_settings" ]]; then
        log_success "VS Code settings are symlinked"
    else
        log_info "VS Code settings not symlinked"
        log_info "Run './dotfiles link' to set up VS Code"
    fi
    
    # Check if code command is available
    if command_exists code; then
        log_success "VS Code command line tool is installed"
        
        # Install extensions
        log_info "Installing VS Code extensions..."
        local extensions=(
            "ms-python.python"
            "esbenp.prettier-vscode"
            "dbaeumer.vscode-eslint"
            "PKief.material-icon-theme"
            "GitHub.copilot"
        )
        
        for ext in "${extensions[@]}"; do
            if code --install-extension "$ext" 2>/dev/null; then
                log_info "✓ Installed $ext"
            else
                log_info "⚠ $ext may already be installed"
            fi
        done
    else
        log_info "VS Code command line tool not found"
        log_info "Install it from VS Code: Shell Command: Install 'code' command in PATH"
    fi
}

# Main function
main() {
    show_header "Xcode & Development Tools Configuration"
    
    # Check Xcode tools
    if ! check_xcode_tools; then
        log_error "Cannot proceed without Xcode Command Line Tools"
        exit 1
    fi
    
    # Backup and merge Xcode settings
    backup_and_merge_xcode_settings
    
    # Note about symlinks
    log_info ""
    log_info "Note: Xcode directories will be symlinked when you run './dotfiles link'"
    log_info ""
    
    # Setup sync function
    install_xcode_sync_function
    
    # Configure iTerm2
    configure_iterm
    
    # Setup VS Code
    setup_vscode
    
    show_footer "Xcode Configuration Complete"
    
    # Summary
    echo ""
    log_info "${BOLD}Summary:${NC}"
    log_info "• Xcode settings backed up and ready for symlinking"
    log_info "• Use 'xcode-sync' to sync snippets to git"
    log_info "• iTerm2 color schemes available for import"
    log_info "• VS Code extensions installed (if available)"
}

# Run main function
main "$@"