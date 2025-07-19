#!/usr/bin/env bash

# Bootstrap script - Full system setup
# This is the main entry point for setting up a new machine

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Continue on error for bootstrap
set +e

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check macOS
    if ! check_macos; then
        log_error "This script requires macOS"
        exit 1
    fi
    
    # Check Xcode Command Line Tools
    if ! are_xcode_tools_installed; then
        log_warning "Xcode Command Line Tools not installed"
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install 2>/dev/null
        
        log_error "Please complete the Xcode Tools installation and run this script again"
        log_info "Installation window should have appeared. If not, run: xcode-select --install"
        exit 1
    fi
    
    log_success "All prerequisites met"
}

# Clone or update dotfiles repository if needed
ensure_dotfiles() {
    log_step "Ensuring dotfiles repository..."
    
    # If we're already in the dotfiles directory, we're good
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log_success "Already in dotfiles repository"
        return 0
    fi
    
    # If dotfiles exist but we're not in it, something is wrong
    if [[ -d "$HOME/.dotfiles" ]]; then
        log_error "Dotfiles exist but script not run from dotfiles directory"
        log_info "Please cd to ~/.dotfiles and run: ./dotfiles bootstrap"
        exit 1
    fi
    
    # Clone dotfiles
    log_info "Cloning dotfiles repository..."
    if git clone https://github.com/marcoscurvello/dotfiles.git "$HOME/.dotfiles"; then
        log_success "Dotfiles cloned successfully"
        cd "$HOME/.dotfiles"
        export DOTFILES_DIR="$HOME/.dotfiles"
    else
        log_error "Failed to clone dotfiles repository"
        exit 1
    fi
}

# Run all setup scripts in order
run_setup() {
    log_step "Running setup scripts..."
    
    local scripts=(
        "shell"     # Configure shell first (installs Oh My Zsh)
        "brew"      # Install Homebrew and packages
        "link"      # Create symlinks
        "macos"     # Configure macOS settings
        "xcode"     # Setup Xcode environment
    )
    
    local failed=()
    
    for script in "${scripts[@]}"; do
        log_step "Running $script setup..."
        
        if bash "$SCRIPT_DIR/${script}.sh"; then
            log_success "$script setup completed"
        else
            log_error "$script setup failed"
            failed+=("$script")
        fi
        
        echo ""  # Add spacing between scripts
    done
    
    # Report results
    if [[ ${#failed[@]} -eq 0 ]]; then
        log_success "All setup scripts completed successfully!"
    else
        log_warning "Some scripts failed: ${failed[*]}"
        log_info "You can run them individually with:"
        for script in "${failed[@]}"; do
            log_info "  ./dotfiles $script"
        done
    fi
}

# Configure git if needed
configure_git() {
    log_step "Checking Git configuration..."
    
    local needs_config=false
    
    # Check if git user is configured
    if ! git config --global user.name &> /dev/null; then
        needs_config=true
    fi
    
    if ! git config --global user.email &> /dev/null; then
        needs_config=true
    fi
    
    if [[ "$needs_config" == true ]]; then
        log_info "Git user configuration needed"
        
        # Get user name
        if ! git config --global user.name &> /dev/null; then
            echo -n "Enter your Git username: "
            read -r git_username
            git config --global user.name "$git_username"
        fi
        
        # Get email
        if ! git config --global user.email &> /dev/null; then
            echo -n "Enter your Git email: "
            read -r git_email
            git config --global user.email "$git_email"
        fi
        
        log_success "Git configuration complete"
    else
        log_success "Git already configured"
    fi
}

# Final setup steps
final_setup() {
    log_step "Performing final setup..."
    
    # Install VS Code extensions if code command exists
    if command_exists code; then
        log_info "Installing VS Code extensions..."
        local extensions=(
            "ms-python.python"
            "esbenp.prettier-vscode"
            "dbaeumer.vscode-eslint"
            "PKief.material-icon-theme"
            "eamodio.gitlens"
            "GitHub.copilot"
        )
        
        for ext in "${extensions[@]}"; do
            code --install-extension "$ext" 2>/dev/null || true
        done
    fi
    
    # Create common directories
    local dirs=(
        "$HOME/Developer"
        "$HOME/Developer/Personal"
        "$HOME/Developer/Work"
        "$HOME/.config"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_info "Creating directory: $dir"
            mkdir -p "$dir"
        fi
    done
    
    log_success "Final setup complete"
}

# Show completion message
show_completion_message() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║                    🎉 Setup Complete! 🎉                      ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║  Your macOS development environment is ready!                 ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║  ${BOLD}Next steps:${NC}${GREEN}                                                  ║${NC}"
    echo -e "${GREEN}║  1. Restart your terminal or run: source ~/.zshrc            ║${NC}"
    echo -e "${GREEN}║  2. Configure Powerlevel10k: p10k configure                  ║${NC}"
    echo -e "${GREEN}║  3. Import iTerm2 color schemes from ~/.dotfiles/iterm-colors║${NC}"
    echo -e "${GREEN}║  4. Customize any settings as needed                          ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║  ${BOLD}Maintenance:${NC}${GREEN}                                                ║${NC}"
    echo -e "${GREEN}║  • Update everything: ./dotfiles update                       ║${NC}"
    echo -e "${GREEN}║  • Sync Xcode snippets: xcode-sync                           ║${NC}"
    echo -e "${GREEN}║  • View all options: ./dotfiles --help                        ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║  ${BOLD}Happy coding! 🚀${NC}${GREEN}                                             ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main function
main() {
    show_header "macOS Development Environment Bootstrap"
    
    # Check prerequisites
    check_prerequisites
    
    # Ensure we have dotfiles
    ensure_dotfiles
    
    # Configure git early
    configure_git
    
    # Run all setup scripts
    run_setup
    
    # Final setup
    final_setup
    
    # Show completion
    show_footer "Bootstrap Process Complete"
    show_completion_message
    
    # Log file reminder
    log_info "Full log available at: $LOG_FILE"
}

# Check if this is being run via curl pipe
if [[ "$0" == "bash" ]] || [[ "$0" == "sh" ]]; then
    # Being run via curl | bash
    # Download and run from the repository
    log_info "Downloading dotfiles bootstrap script..."
    
    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Clone repository
    if git clone https://github.com/marcoscurvello/dotfiles.git; then
        cd dotfiles
        exec ./scripts/bootstrap.sh "$@"
    else
        log_error "Failed to clone repository"
        exit 1
    fi
else
    # Being run directly
    main "$@"
fi