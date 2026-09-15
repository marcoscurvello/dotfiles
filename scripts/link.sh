#!/usr/bin/env bash

# Create/update configuration file symlinks via Home Manager.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

main() {
    show_header "Activating Dotfiles"
    
    # Change to dotfiles directory
    cd "$DOTFILES_DIR" || {
        log_error "Failed to change to dotfiles directory"
        exit 1
    }
    
    # Check if the Nix-backed install script exists
    if [[ ! -f "install" ]]; then
        log_error "Install script not found"
        log_info "This is likely a configuration issue with the repository"
        exit 1
    fi
    
    log_step "Running Home Manager to activate symlinks..."
    
    local activation_status=0
    if ./install; then
        log_success "Dotfiles activated successfully"
    else
        activation_status=1
        log_error "Home Manager activation failed (see above)"
        log_info "If Nix is missing, run: ./dotfiles nix"
    fi
    
    # Verify key symlinks
    log_step "Verifying symlinks..."
    
    local symlinks_to_check=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
        "$HOME/.p10k.zsh"
        "$HOME/.aerospace.toml"
        "$HOME/.config/herdr/config.toml"
        "$HOME/.config/nvim"
        "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
        "$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
        "$HOME/Library/Developer/Xcode/UserData/KeyBindings"
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
    
    show_footer "Dotfiles Activation Complete"

    return "$activation_status"
}

# Run main function
main "$@"
