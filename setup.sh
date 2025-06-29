#!/usr/bin/env bash

# macOS Development Environment Setup Script
# Author: Marcos Curvello
# Description: One-command setup for complete development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${PURPLE}==>${NC} ${CYAN}$1${NC}"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi
}

# Check for Command Line Tools
check_xcode_tools() {
    log_step "Checking for Xcode Command Line Tools..."
    
    if ! xcode-select -p &> /dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        log_warning "Please complete the Xcode Command Line Tools installation and run this script again."
        exit 1
    else
        log_success "Xcode Command Line Tools are installed"
    fi
}

# Install Homebrew
install_homebrew() {
    log_step "Installing Homebrew..."
    
    if command -v brew &> /dev/null; then
        log_success "Homebrew is already installed"
    else
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zprofile
            export PATH="/opt/homebrew/bin:$PATH"
        fi
        
        log_success "Homebrew installed successfully"
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    log_step "Setting up dotfiles..."
    
    DOTFILES_DIR="$HOME/.dotfiles"
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_info "Dotfiles directory already exists. Updating..."
        cd "$DOTFILES_DIR"
        git pull origin main
    else
        log_info "Cloning dotfiles repository..."
        git clone https://github.com/marcoscurvello/dotfiles.git "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi
    
    log_success "Dotfiles repository ready"
}

# Install packages from Brewfile
install_packages() {
    log_step "Installing packages from Brewfile..."
    
    cd "$HOME/.dotfiles"
    
    if [[ -f "Brewfile" ]]; then
        log_info "Installing Homebrew packages..."
        brew bundle --file=Brewfile
        log_success "All packages installed successfully"
    else
        log_warning "Brewfile not found, skipping package installation"
    fi
}

# Run dotbot installation
run_dotbot() {
    log_step "Configuring dotfiles with Dotbot..."
    
    cd "$HOME/.dotfiles"
    
    if [[ -f "install" ]]; then
        log_info "Running dotbot installation..."
        ./install
        log_success "Dotfiles configured successfully"
    else
        log_error "Dotbot install script not found"
        exit 1
    fi
}

# Configure shell
configure_shell() {
    log_step "Configuring shell..."
    
    # Change default shell to zsh if not already
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s /bin/zsh
        log_success "Default shell changed to zsh"
    else
        log_success "Shell is already set to zsh"
    fi
    
    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log_success "Oh My Zsh is already installed"
    fi
}

# Configure git if needed
configure_git() {
    log_step "Configuring Git..."
    
    # Check if git user is configured
    if ! git config --global user.name &> /dev/null; then
        echo -n "Enter your Git username: "
        read -r git_username
        git config --global user.name "$git_username"
    fi
    
    if ! git config --global user.email &> /dev/null; then
        echo -n "Enter your Git email: "
        read -r git_email
        git config --global user.email "$git_email"
    fi
    
    log_success "Git configuration complete"
}

# Configure VS Code
configure_vscode() {
    log_step "Configuring VS Code..."
    
    # Install VS Code extensions if VS Code is installed
    if command -v code &> /dev/null; then
        log_info "Installing VS Code extensions..."
        
        # Essential extensions
        extensions=(
            "ms-vscode.vscode-typescript-next"
            "ms-python.python"
            "ms-vscode.cpptools"
            "vadimcn.vscode-lldb"
            "sswg.swift-lang"
            "GitLab.gitlab-workflow"
            "GitHub.copilot"
            "ms-vscode.theme-monokai-dimmed"
            "PKief.material-icon-theme"
            "formulahendry.auto-rename-tag"
            "esbenp.prettier-vscode"
            "ms-vscode.vscode-json"
            "redhat.vscode-yaml"
            "ms-vscode-remote.remote-containers"
        )
        
        for extension in "${extensions[@]}"; do
            code --install-extension "$extension" --force &> /dev/null || true
        done
        
        log_success "VS Code extensions installed"
    else
        log_warning "VS Code not found, skipping extension installation"
    fi
}

# macOS system preferences
configure_macos() {
    log_step "Configuring macOS system preferences..."
    
    # Dock preferences
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.5
    
    # Finder preferences
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    
    # Screenshots to Desktop/Screenshots
    mkdir -p "$HOME/Desktop/Screenshots"
    defaults write com.apple.screencapture location "$HOME/Desktop/Screenshots"
    
    # Restart affected applications
    killall Dock 2> /dev/null || true
    killall Finder 2> /dev/null || true
    
    log_success "macOS system preferences configured"
}

# Final setup steps
final_setup() {
    log_step "Completing setup..."
    
    # Source the new shell configuration
    if [[ -f "$HOME/.zshrc" ]]; then
        log_info "Shell configuration will be loaded on next terminal session"
    fi
    
    # Create screenshots directory
    mkdir -p "$HOME/Desktop/Screenshots"
    
    log_success "Setup complete!"
}

# Main installation function
main() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║          macOS Development Environment Setup                  ║"
    echo "║                                                               ║"
    echo "║  This script will install and configure:                      ║"
    echo "║  • Homebrew package manager                                   ║"
    echo "║  • Essential CLI tools (fzf, ripgrep, bat, eza, etc.)         ║"
    echo "║  • Development applications (VS Code, iTerm2, Docker)         ║"
    echo "║  • Shell configuration (Zsh + Oh My Zsh + Powerlevel10k)      ║"
    echo "║  • Git configuration                                          ║"
    echo "║  • macOS system preferences                                   ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -n "Do you want to continue? [y/N]: "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled by user"
        exit 0
    fi
    
    # Run setup steps
    check_macos
    check_xcode_tools
    install_homebrew
    clone_dotfiles
    install_packages
    run_dotbot
    configure_shell
    configure_git
    configure_vscode
    configure_macos
    final_setup
    
    echo -e "\n${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║                    🎉 Setup Complete! 🎉                      ║"
    echo "║                                                               ║"
    echo "║  Your macOS development environment is ready!                 ║"
    echo "║                                                               ║"
    echo "║  Next steps:                                                  ║"
    echo "║  1. Restart your terminal or run: source ~/.zshrc             ║"
    echo "║  2. Configure Powerlevel10k: p10k configure                   ║"
    echo "║  3. Open VS Code to complete any remaining setup              ║"
    echo "║  4. Customize settings as needed                              ║"
    echo "║                                                               ║"
    echo "║  Happy coding! 🚀                                             ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run the main function
main "$@"