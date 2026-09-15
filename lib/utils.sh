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
    { touch "$LOG_FILE"; } 2>/dev/null || true
fi

# Logging functions that output to both console and file
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file with timestamp when available.
    { echo "[$timestamp] [$level] $message" >> "$LOG_FILE"; } 2>/dev/null || true
    
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
            { echo "" >> "$LOG_FILE"; } 2>/dev/null || true
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

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Xcode Command Line Tools are installed
are_xcode_tools_installed() {
    xcode-select -p &> /dev/null
}

# Print a separator line
print_separator() {
    echo -e "${BOLD}════════════════════════════════════════════════════════════════${NC}"
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
export -f check_macos command_exists are_xcode_tools_installed
export -f print_separator
export -f show_header show_footer
