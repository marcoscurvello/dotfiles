#!/usr/bin/env bash

# Configure shell environment (Zsh, Oh My Zsh, etc.)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

# Change default shell to zsh
set_default_shell() {
    log_step "Checking default shell..."
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_success "Default shell is already zsh"
        return 0
    fi
    
    log_info "Current shell: $SHELL"
    log_info "Changing default shell to zsh..."
    
    # Check if zsh is in allowed shells
    if ! grep -q "/bin/zsh" /etc/shells; then
        log_error "/bin/zsh not found in /etc/shells"
        return 1
    fi
    
    # Change shell
    if chsh -s /bin/zsh; then
        log_success "Default shell changed to zsh"
        log_info "You'll need to restart your terminal for this to take effect"
        return 0
    else
        log_error "Failed to change default shell"
        log_info "You may need to run: chsh -s /bin/zsh"
        return 1
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    log_step "Checking Oh My Zsh installation..."
    
    if is_oh_my_zsh_installed; then
        log_success "Oh My Zsh is already installed"
        
        # Update Oh My Zsh
        log_info "Updating Oh My Zsh..."
        if [[ -f "$HOME/.oh-my-zsh/tools/upgrade.sh" ]]; then
            env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/upgrade.sh" 2>/dev/null || {
                log_warning "Failed to update Oh My Zsh"
            }
        fi
        
        return 0
    fi
    
    log_info "Installing Oh My Zsh..."
    
    # Backup existing .zshrc if it exists and is not a symlink
    if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
        backup_file "$HOME/.zshrc"
    fi
    
    # Install Oh My Zsh unattended
    if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        log_success "Oh My Zsh installed successfully"
        
        # Remove the default .zshrc created by Oh My Zsh
        # (we'll use our own from dotfiles)
        if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
            log_info "Removing default Oh My Zsh .zshrc (will be replaced by dotfiles)"
            rm -f "$HOME/.zshrc"
        fi
        
        return 0
    else
        log_error "Failed to install Oh My Zsh"
        return 1
    fi
}

# Configure Powerlevel10k
configure_p10k() {
    log_step "Checking Powerlevel10k configuration..."
    
    # Check if p10k is configured
    if [[ -f "$HOME/.p10k.zsh" ]]; then
        log_success "Powerlevel10k configuration found"
        return 0
    fi
    
    log_info "Powerlevel10k not configured yet"
    log_info "Run 'p10k configure' after setup to configure your prompt"
}

# Verify shell plugins
verify_plugins() {
    log_step "Verifying shell plugins..."
    
    local plugins=(
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "powerlevel10k"
    )
    
    local missing=()
    
    for plugin in "${plugins[@]}"; do
        if is_brew_formula_installed "$plugin"; then
            log_info "✓ $plugin"
        else
            log_warning "✗ $plugin (missing)"
            missing+=("$plugin")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Some shell plugins are missing"
        log_info "Run './dotfiles brew' to install missing plugins"
    else
        log_success "All shell plugins are installed"
    fi
}

# Create shell directories
create_shell_directories() {
    log_step "Creating shell directories..."
    
    local dirs=(
        "$HOME/.zsh"
        "$HOME/.zsh/functions"
        "$HOME/.config"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_info "Creating directory: $dir"
            mkdir -p "$dir"
        fi
    done
    
    log_success "Shell directories ready"
}

# Main function
main() {
    show_header "Shell Configuration"
    
    # Set default shell
    set_default_shell
    
    # Install Oh My Zsh
    install_oh_my_zsh
    
    # Create necessary directories
    create_shell_directories
    
    # Verify plugins
    verify_plugins
    
    # Check P10k
    configure_p10k
    
    show_footer "Shell Configuration Complete"
    
    # Final notes
    echo ""
    log_info "${BOLD}Next steps:${NC}"
    log_info "1. Run './dotfiles link' to create configuration symlinks"
    log_info "2. Restart your terminal or run: source ~/.zshrc"
    log_info "3. Configure Powerlevel10k: p10k configure"
}

# Run main function
main "$@"