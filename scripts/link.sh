#!/usr/bin/env bash

# Create/update configuration file symlinks
# This is the equivalent of the old "install" script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

main() {
    show_header "Updating Configuration Symlinks"
    
    # Change to dotfiles directory
    cd "$DOTFILES_DIR" || {
        log_error "Failed to change to dotfiles directory"
        exit 1
    }
    
    # Check if Dotbot install script exists
    if [[ ! -f "install" ]]; then
        log_error "Dotbot install script not found"
        log_info "This is likely a configuration issue with the repository"
        exit 1
    fi
    
    log_step "Running Dotbot to create symlinks..."
    
    # Run dotbot
    if ./install; then
        log_success "Symlinks created/updated successfully"
    else
        log_error "Dotbot encountered errors (see above)"
        log_info "Some symlinks may have been created despite errors"
    fi
    
    # Verify key symlinks
    log_step "Verifying symlinks..."
    
    local symlinks_to_check=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
        "$HOME/.p10k.zsh"
        "$HOME/.aerospace.toml"
        "$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
        "$HOME/Library/Developer/Xcode/UserData/KeyBindings"
        "$HOME/Library/Application Support/Code/User/settings.json"
    )
    
    local success_count=0
    local total_count=${#symlinks_to_check[@]}
    
    for link in "${symlinks_to_check[@]}"; do
        if [[ -L "$link" ]]; then
            ((success_count++))
            log_info "✓ $(basename "$link")"
        elif [[ -e "$link" ]]; then
            log_warning "⚠ $(basename "$link") exists but is not a symlink"
        else
            log_info "✗ $(basename "$link") not found"
        fi
    done
    
    log_info "Symlinks verified: $success_count/$total_count"
    
    show_footer "Symlink Update Complete"
}

# Run main function
main "$@"