#!/usr/bin/env bash

# Shared utility functions for dotfiles scripts
# This file is sourced by all other scripts

# Exit on any error (scripts can override if needed)
set -e

# Global variables
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
export LOG_FILE="$HOME/.dotfiles-install.log"

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# Initialize log file
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

# Logging functions that output to both console and file
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file with timestamp
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Console output with colors
    case "$level" in
        INFO)
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        SUCCESS)
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        WARNING)
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        ERROR)
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        STEP)
            echo -e "\n${PURPLE}==>${NC} ${CYAN}$message${NC}"
            echo "" >> "$LOG_FILE"  # Add blank line in log for readability
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Convenience logging functions
log_info() { log "INFO" "$@"; }
log_success() { log "SUCCESS" "$@"; }
log_warning() { log "WARNING" "$@"; }
log_error() { log "ERROR" "$@"; }
log_step() { log "STEP" "$@"; }

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only."
        return 1
    fi
    return 0
}

# Detect architecture
detect_arch() {
    local arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        echo "arm64"
    else
        echo "x86_64"
    fi
}

# Set Homebrew path based on architecture
setup_homebrew_path() {
    local arch=$(detect_arch)
    if [[ "$arch" == "arm64" ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    else
        export HOMEBREW_PREFIX="/usr/local"
    fi
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Homebrew is installed
is_homebrew_installed() {
    setup_homebrew_path
    command_exists brew
}

# Check if a Homebrew formula is installed
is_brew_formula_installed() {
    if is_homebrew_installed; then
        brew list --formula | grep -q "^$1$"
    else
        return 1
    fi
}

# Check if a Homebrew cask is installed
is_brew_cask_installed() {
    if is_homebrew_installed; then
        brew list --cask | grep -q "^$1$"
    else
        return 1
    fi
}

# Check if Oh My Zsh is installed
is_oh_my_zsh_installed() {
    [[ -d "$HOME/.oh-my-zsh" ]]
}

# Check if Xcode Command Line Tools are installed
are_xcode_tools_installed() {
    xcode-select -p &> /dev/null
}

# Create a backup with timestamp
backup_file() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up $file to $backup"
        cp -r "$file" "$backup"
    fi
}

# Safely create a symlink
safe_symlink() {
    local source="$1"
    local target="$2"
    
    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        backup_file "$target"
        rm -rf "$target"
    fi
    
    # Create parent directory if needed
    local parent_dir=$(dirname "$target")
    if [[ ! -d "$parent_dir" ]]; then
        log_info "Creating directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi
    
    # Create symlink
    if [[ ! -L "$target" ]]; then
        log_info "Creating symlink: $target -> $source"
        ln -sf "$source" "$target"
    fi
}

# Run a command and continue on error
run_command() {
    local cmd="$1"
    local description="${2:-Running command}"
    
    log_info "$description"
    log_info "Command: $cmd"
    
    # Temporarily disable exit on error
    set +e
    eval "$cmd"
    local exit_code=$?
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        log_success "Command completed successfully"
    else
        log_error "Command failed with exit code $exit_code (continuing...)"
    fi
    
    return $exit_code
}

# Check if script is being sourced or executed
is_sourced() {
    [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

# Print a separator line
print_separator() {
    echo -e "${BOLD}════════════════════════════════════════════════════════════════${NC}"
}

# Get user confirmation
confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-y}"
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi
    
    read -r -p "$prompt" response
    response=${response,,} # to lowercase
    
    if [[ -z "$response" ]]; then
        response="$default"
    fi
    
    [[ "$response" == "y" ]]
}

# Show script header
show_header() {
    local title="$1"
    print_separator
    echo -e "${BOLD}$title${NC}"
    echo -e "${BLUE}Log file: $LOG_FILE${NC}"
    print_separator
    log_step "$title"
}

# Show script footer
show_footer() {
    local title="${1:-Script completed}"
    print_separator
    log_success "$title"
    echo -e "${BLUE}Check log file for details: $LOG_FILE${NC}"
}

# Export functions so they're available to scripts that source this file
export -f log log_info log_success log_warning log_error log_step
export -f check_macos detect_arch setup_homebrew_path
export -f command_exists is_homebrew_installed is_brew_formula_installed is_brew_cask_installed
export -f is_oh_my_zsh_installed are_xcode_tools_installed
export -f backup_file safe_symlink run_command
export -f is_sourced print_separator confirm
export -f show_header show_footer