#!/usr/bin/env bash

# Zsh-compatible menu system for dotfiles management
# This version is optimized for terminals that have issues with the fancy menu

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Menu items and their corresponding scripts
MENU_ITEMS=(
    "Full Bootstrap (First time setup)"
    "Update Everything (git pull + brew upgrade)"
    "Update Symlinks"
    "Install/Update Homebrew Packages"
    "Configure macOS Settings"
    "Configure Shell (Zsh/Oh-My-Zsh)"
    "Setup Xcode (Themes/Snippets)"
)

MENU_COMMANDS=(
    "bootstrap"
    "update"
    "link"
    "brew"
    "macos"
    "shell"
    "xcode"
)

# Simple menu using bash select
show_menu() {
    # Force output to terminal
    exec 1>&2
    
    # Print header
    echo ""
    echo -e "${BOLD}Dotfiles Manager v2.0${NC}"
    echo -e "${BOLD}═══════════════════════════════════════${NC}"
    echo ""
    
    # Use bash's built-in select menu
    PS3=$'\nPlease select an option (1-8): '
    
    # Add Exit option to the array for select
    local menu_with_exit=("${MENU_ITEMS[@]}" "Exit")
    
    select opt in "${menu_with_exit[@]}"; do
        case $REPLY in
            [1-7])
                local idx=$((REPLY-1))
                local cmd="${MENU_COMMANDS[$idx]}"
                local script="$DOTFILES_DIR/scripts/${cmd}.sh"
                
                echo ""
                log_info "Running: ${MENU_ITEMS[$idx]}"
                echo ""
                
                if [[ -f "$script" ]]; then
                    # Run script
                    bash "$script"
                    local exit_code=$?
                    
                    if [[ $exit_code -eq 0 ]]; then
                        echo ""
                        log_success "${MENU_ITEMS[$idx]} completed"
                    else
                        echo ""
                        log_error "${MENU_ITEMS[$idx]} failed (exit code: $exit_code)"
                    fi
                else
                    log_error "Script not found: $script"
                fi
                
                echo ""
                echo "Press Enter to continue..."
                read -r
                
                # Reshow header after action
                echo ""
                echo -e "${BOLD}Dotfiles Manager v2.0${NC}"
                echo -e "${BOLD}═══════════════════════════════════════${NC}"
                echo ""
                ;;
            8)
                echo ""
                echo -e "${GREEN}Thanks for using Dotfiles Manager!${NC}"
                exit 0
                ;;
            *)
                echo ""
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

# Main execution
main() {
    # Check if we're in an interactive terminal
    if [[ ! -t 0 ]] || [[ ! -t 1 ]]; then
        echo "Error: This menu requires an interactive terminal"
        echo ""
        echo "Try running specific commands instead:"
        echo "  ./dotfiles bootstrap    # First-time setup"
        echo "  ./dotfiles update       # Update everything"
        echo "  ./dotfiles link         # Update symlinks"
        echo ""
        echo "Or run './dotfiles --help' for all commands"
        exit 1
    fi
    
    # Run the menu
    show_menu
}

# Run main if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi