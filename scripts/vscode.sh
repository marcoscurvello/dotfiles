#!/usr/bin/env bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Source utilities
source "$SCRIPT_DIR/../lib/utils.sh"

# VSCode paths
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"
VSCODE_KEYBINDINGS="$VSCODE_USER_DIR/keybindings.json"

# Dotfiles VSCode paths
DOTFILES_VSCODE_DIR="$DOTFILES_DIR/vscode"
DOTFILES_VSCODE_SETTINGS="$DOTFILES_VSCODE_DIR/settings.json"
DOTFILES_VSCODE_KEYBINDINGS="$DOTFILES_VSCODE_DIR/keybindings.json"
DOTFILES_VSCODE_EXTENSIONS="$DOTFILES_VSCODE_DIR/extensions.txt"

# Function to check if VSCode is installed
check_vscode() {
    if ! command -v code &> /dev/null; then
        return 1
    fi
    return 0
}

# Function to backup VSCode settings to dotfiles
backup_vscode_settings() {
    log_info "Backing up VSCode settings..."
    
    # Create VSCode directory in dotfiles if it doesn't exist
    mkdir -p "$DOTFILES_VSCODE_DIR"
    
    # Backup settings.json
    if [ -f "$VSCODE_SETTINGS" ]; then
        cp "$VSCODE_SETTINGS" "$DOTFILES_VSCODE_SETTINGS"
        log_success "Backed up settings.json"
    else
        log_warning "No settings.json found at $VSCODE_SETTINGS"
    fi
    
    # Backup keybindings.json
    if [ -f "$VSCODE_KEYBINDINGS" ]; then
        cp "$VSCODE_KEYBINDINGS" "$DOTFILES_VSCODE_KEYBINDINGS"
        log_success "Backed up keybindings.json"
    else
        log_warning "No keybindings.json found at $VSCODE_KEYBINDINGS"
    fi
    
    log_info "VSCode settings backup complete"
}

# Function to restore VSCode settings from dotfiles
restore_vscode_settings() {
    log_info "Restoring VSCode settings..."
    
    # Create VSCode User directory if it doesn't exist
    mkdir -p "$VSCODE_USER_DIR"
    
    # Restore settings.json
    if [ -f "$DOTFILES_VSCODE_SETTINGS" ]; then
        cp "$DOTFILES_VSCODE_SETTINGS" "$VSCODE_SETTINGS"
        log_success "Restored settings.json"
    else
        log_warning "No settings.json found in dotfiles"
    fi
    
    # Restore keybindings.json
    if [ -f "$DOTFILES_VSCODE_KEYBINDINGS" ]; then
        cp "$DOTFILES_VSCODE_KEYBINDINGS" "$VSCODE_KEYBINDINGS"
        log_success "Restored keybindings.json"
    else
        log_warning "No keybindings.json found in dotfiles"
    fi
    
    log_info "VSCode settings restore complete"
}

# Function to install VSCode extensions
install_vscode_extensions() {
    log_info "Installing VSCode extensions..."
    
    if [ ! -f "$DOTFILES_VSCODE_EXTENSIONS" ]; then
        log_warning "No extensions.txt file found"
        return
    fi
    
    if ! check_vscode; then
        log_error "VSCode is not installed. Please install VSCode first."
        return 1
    fi
    
    # Read extensions file and install each extension
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Extract extension ID from lines like "code --install-extension <extension-id>"
        if [[ "$line" =~ code[[:space:]]+--install-extension[[:space:]]+([^[:space:]]+) ]]; then
            extension="${BASH_REMATCH[1]}"
            log_info "Installing extension: $extension"
            code --install-extension "$extension" || log_warning "Failed to install $extension"
        fi
    done < "$DOTFILES_VSCODE_EXTENSIONS"
    
    log_success "VSCode extensions installation complete"
}

# Function to show VSCode sync status
vscode_status() {
    log_info "VSCode sync status:"
    echo
    
    # Check settings.json
    if [ -f "$VSCODE_SETTINGS" ] && [ -f "$DOTFILES_VSCODE_SETTINGS" ]; then
        if diff -q "$VSCODE_SETTINGS" "$DOTFILES_VSCODE_SETTINGS" > /dev/null; then
            log_success "settings.json is in sync"
        else
            log_warning "settings.json has changes"
            echo "  Run 'vscode-sync' to backup your current settings"
        fi
    else
        if [ ! -f "$VSCODE_SETTINGS" ]; then
            log_warning "No settings.json in VSCode directory"
        fi
        if [ ! -f "$DOTFILES_VSCODE_SETTINGS" ]; then
            log_warning "No settings.json in dotfiles"
        fi
    fi
    
    # Check keybindings.json
    if [ -f "$VSCODE_KEYBINDINGS" ] && [ -f "$DOTFILES_VSCODE_KEYBINDINGS" ]; then
        if diff -q "$VSCODE_KEYBINDINGS" "$DOTFILES_VSCODE_KEYBINDINGS" > /dev/null; then
            log_success "keybindings.json is in sync"
        else
            log_warning "keybindings.json has changes"
            echo "  Run 'vscode-sync' to backup your current settings"
        fi
    else
        if [ ! -f "$VSCODE_KEYBINDINGS" ]; then
            log_warning "No keybindings.json in VSCode directory"
        fi
        if [ ! -f "$DOTFILES_VSCODE_KEYBINDINGS" ]; then
            log_warning "No keybindings.json in dotfiles"
        fi
    fi
}

# Main setup function
setup_vscode() {
    log_step "Setting up VSCode"
    
    if ! check_vscode; then
        log_warning "VSCode is not installed. Skipping VSCode setup."
        log_info "Install VSCode and run './dotfiles vscode' to set up your configuration."
        return
    fi
    
    restore_vscode_settings
    install_vscode_extensions
    
    log_success "VSCode setup complete!"
}

# Main function to handle different commands
main() {
    case "${1:-setup}" in
        backup)
            backup_vscode_settings
            ;;
        restore)
            restore_vscode_settings
            ;;
        extensions)
            install_vscode_extensions
            ;;
        status)
            vscode_status
            ;;
        setup)
            setup_vscode
            ;;
        *)
            log_error "Unknown command: $1"
            echo "Usage: $0 [backup|restore|extensions|status|setup]"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi