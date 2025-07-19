#!/usr/bin/env bash

# Install and manage Homebrew packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

# Install Homebrew if not present
install_homebrew() {
    log_step "Checking Homebrew installation..."
    
    setup_homebrew_path
    
    if command_exists brew; then
        log_success "Homebrew is already installed"
        log_info "Homebrew version: $(brew --version | head -1)"
        return 0
    fi
    
    log_info "Homebrew not found. Installing..."
    
    # Run Homebrew installer
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        log_success "Homebrew installed successfully"
        
        # Add Homebrew to PATH for current session
        setup_homebrew_path
        
        # Add to shell profile for future sessions
        local shell_profile="$HOME/.zprofile"
        if [[ ! -f "$shell_profile" ]] || ! grep -q "$HOMEBREW_PREFIX/bin" "$shell_profile"; then
            echo "export PATH=\"$HOMEBREW_PREFIX/bin:\$PATH\"" >> "$shell_profile"
            log_info "Added Homebrew to PATH in $shell_profile"
        fi
        
        return 0
    else
        log_error "Failed to install Homebrew"
        return 1
    fi
}

# Update Homebrew
update_homebrew() {
    log_step "Updating Homebrew..."
    
    if brew update; then
        log_success "Homebrew updated successfully"
    else
        log_warning "Failed to update Homebrew (continuing...)"
    fi
}

# Install packages from Brewfile
install_packages() {
    log_step "Installing packages from Brewfile..."
    
    local brewfile="$DOTFILES_DIR/Brewfile"
    
    if [[ ! -f "$brewfile" ]]; then
        log_error "Brewfile not found at: $brewfile"
        return 1
    fi
    
    # Count packages before installation
    local before_formulas=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
    local before_casks=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
    
    log_info "Installing packages from Brewfile..."
    log_info "This may take a while depending on what needs to be installed..."
    
    # Run brew bundle
    if brew bundle --file="$brewfile"; then
        log_success "Brew bundle completed"
    else
        log_warning "Brew bundle encountered some errors (see above)"
    fi
    
    # Count packages after installation
    local after_formulas=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
    local after_casks=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
    
    # Calculate installed packages
    local new_formulas=$((after_formulas - before_formulas))
    local new_casks=$((after_casks - before_casks))
    
    log_info "Installed $new_formulas new formulae and $new_casks new casks"
    log_info "Total: $after_formulas formulae and $after_casks casks installed"
}

# Verify critical packages
verify_critical_packages() {
    log_step "Verifying critical packages..."
    
    local critical_packages=(
        "powerlevel10k"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "git"
        "eza"
        "bat"
        "fzf"
    )
    
    local missing_packages=()
    
    for pkg in "${critical_packages[@]}"; do
        if is_brew_formula_installed "$pkg"; then
            log_info "✓ $pkg"
        else
            log_warning "✗ $pkg (missing)"
            missing_packages+=("$pkg")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_warning "Some critical packages are missing"
        log_info "Attempting to install missing packages..."
        
        for pkg in "${missing_packages[@]}"; do
            log_info "Installing $pkg..."
            if brew install "$pkg"; then
                log_success "$pkg installed"
            else
                log_error "Failed to install $pkg"
            fi
        done
    else
        log_success "All critical packages are installed"
    fi
}

# Cleanup old versions
cleanup_homebrew() {
    log_step "Cleaning up old versions..."
    
    # Remove old versions
    if brew cleanup; then
        log_success "Cleanup completed"
    else
        log_warning "Cleanup encountered issues"
    fi
    
    # Check for problems
    log_info "Running brew doctor..."
    if brew doctor; then
        log_success "Homebrew is ready to brew!"
    else
        log_warning "Brew doctor found some issues (see above)"
        log_info "These issues are usually not critical"
    fi
}

# Main function
main() {
    show_header "Homebrew Package Management"
    
    # Check macOS
    if ! check_macos; then
        exit 1
    fi
    
    # Install Homebrew if needed
    if ! install_homebrew; then
        log_error "Cannot proceed without Homebrew"
        exit 1
    fi
    
    # Update Homebrew
    update_homebrew
    
    # Install packages
    install_packages
    
    # Verify critical packages
    verify_critical_packages
    
    # Cleanup
    cleanup_homebrew
    
    show_footer "Homebrew Setup Complete"
}

# Run main function
main "$@"