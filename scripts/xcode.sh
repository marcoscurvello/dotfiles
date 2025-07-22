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
    
    # Directories to handle with symlinks
    local xcode_dirs=("CodeSnippets" "KeyBindings")
    
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
    
    # Handle FontAndColorThemes differently (copy instead of symlink)
    handle_xcode_themes
    
    # Handle Xcode preferences (backup only, no symlink)
    local xcode_prefs="$HOME/Library/Preferences/com.apple.dt.Xcode.plist"
    if [[ -f "$xcode_prefs" ]]; then
        log_info "Backing up Xcode preferences..."
        mkdir -p "$backup_dir"
        cp "$xcode_prefs" "$backup_dir/"
        log_info "✓ Backed up Xcode preferences"
    fi
}

# Handle Xcode themes - copy instead of symlink to preserve local themes
handle_xcode_themes() {
    log_step "Handling Xcode color themes..."
    
    local xcode_themes="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
    local dotfiles_themes="$DOTFILES_DIR/xcode/FontAndColorThemes"
    
    # Ensure both directories exist
    mkdir -p "$xcode_themes" "$dotfiles_themes"
    
    # Copy themes from dotfiles to Xcode (preserving existing)
    if [[ -d "$dotfiles_themes" ]] && [[ "$(ls -A "$dotfiles_themes" 2>/dev/null)" ]]; then
        log_info "Installing themes from dotfiles..."
        for theme in "$dotfiles_themes"/*.xccolortheme; do
            if [[ -f "$theme" ]]; then
                local basename=$(basename "$theme")
                local dest="$xcode_themes/$basename"
                
                if [[ ! -f "$dest" ]]; then
                    cp "$theme" "$dest"
                    log_info "✓ Installed theme: $basename"
                else
                    log_info "✓ Theme already exists: $basename"
                fi
            fi
        done
    fi
    
    # Copy any new local themes back to dotfiles
    if [[ -d "$xcode_themes" ]] && [[ "$(ls -A "$xcode_themes" 2>/dev/null)" ]]; then
        log_info "Backing up local themes to dotfiles..."
        for theme in "$xcode_themes"/*.xccolortheme; do
            if [[ -f "$theme" ]]; then
                local basename=$(basename "$theme")
                local dest="$dotfiles_themes/$basename"
                
                if [[ ! -f "$dest" ]]; then
                    cp "$theme" "$dest"
                    log_info "✓ Backed up theme: $basename"
                fi
            fi
        done
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
    
    show_footer "Xcode Configuration Complete"
    
    # Summary
    echo ""
    log_info "${BOLD}Summary:${NC}"
    log_info "• Xcode settings backed up and ready for symlinking"
    log_info "• Use 'xcode-sync' to sync snippets to git"
    log_info "• iTerm2 color schemes available for import"
}

# Run main function
main "$@"