#!/usr/bin/env bash

# Interactive menu system for dotfiles management
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Menu items and their corresponding scripts
declare -a MENU_ITEMS=(
    "Full Bootstrap (First time setup)"
    "Update Symlinks"
    "Install/Update Homebrew Packages"
    "Configure macOS Settings"
    "Configure Shell (Zsh/Oh-My-Zsh)"
    "Setup Xcode (Themes/Snippets)"
    "Update Everything"
)

declare -a MENU_COMMANDS=(
    "bootstrap"
    "link"
    "brew"
    "macos"
    "shell"
    "xcode"
    "update"
)

declare -a MENU_DESCRIPTIONS=(
    "Complete system setup including all components"
    "Create/update configuration file symlinks"
    "Install Homebrew and all packages from Brewfile"
    "Apply macOS system preferences and settings"
    "Install Oh My Zsh and configure shell environment"
    "Setup Xcode themes, snippets, and preferences"
    "Pull latest dotfiles and update all components"
)

# Track selected items
declare -a SELECTED_ITEMS=()

# Initialize selected items array
init_selected_items() {
    for i in "${!MENU_ITEMS[@]}"; do
        SELECTED_ITEMS[$i]=0
    done
}

# Check component status
check_component_status() {
    local component="$1"
    case "$component" in
        "link")
            # Check if major symlinks exist
            [[ -L "$HOME/.zshrc" ]] && echo "✓" || echo "✗"
            ;;
        "brew")
            is_homebrew_installed && echo "✓" || echo "✗"
            ;;
        "shell")
            is_oh_my_zsh_installed && echo "✓" || echo "✗"
            ;;
        "xcode")
            [[ -L "$HOME/Library/Developer/Xcode/UserData/CodeSnippets" ]] && echo "✓" || echo "✗"
            ;;
        *)
            echo "?"
            ;;
    esac
}

# Display menu
display_menu() {
    clear
    echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║          Dotfiles Manager v2.0                       ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  What would you like to do?                          ║${NC}"
    echo -e "${BOLD}║                                                      ║${NC}"
    
    for i in "${!MENU_ITEMS[@]}"; do
        local item="${MENU_ITEMS[$i]}"
        local cmd="${MENU_COMMANDS[$i]}"
        local selected="${SELECTED_ITEMS[$i]}"
        local status=$(check_component_status "$cmd")
        local checkbox="[ ]"
        
        if [[ $selected -eq 1 ]]; then
            checkbox="[${GREEN}✓${NC}]"
        fi
        
        # Highlight current item
        if [[ $i -eq $CURRENT_ITEM ]]; then
            echo -e "${BOLD}║  ${CYAN}→${NC} $checkbox $(($i + 1)). $item ${YELLOW}[$status]${NC}"
        else
            echo -e "${BOLD}║${NC}    $checkbox $(($i + 1)). $item ${YELLOW}[$status]${NC}"
        fi
    done
    
    echo -e "${BOLD}║                                                      ║${NC}"
    echo -e "${BOLD}║  ${CYAN}↑/↓${NC} Navigate  ${CYAN}Space${NC} Select  ${CYAN}Enter${NC} Run          ║${NC}"
    echo -e "${BOLD}║  ${CYAN}a${NC} Select All   ${CYAN}n${NC} Select None  ${CYAN}q${NC} Quit            ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
    
    # Show descriptions for current item
    if [[ -n "${MENU_DESCRIPTIONS[$CURRENT_ITEM]}" ]]; then
        echo ""
        echo -e "${BLUE}ℹ ${NC}${MENU_DESCRIPTIONS[$CURRENT_ITEM]}"
    fi
}

# Handle keypress
handle_keypress() {
    local key
    IFS= read -rsn1 key
    
    case "$key" in
        # Handle arrow keys (they send escape sequences)
        $'\x1b')
            read -rsn2 key
            case "$key" in
                '[A') # Up arrow
                    ((CURRENT_ITEM--))
                    if [[ $CURRENT_ITEM -lt 0 ]]; then
                        CURRENT_ITEM=$((${#MENU_ITEMS[@]} - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    ((CURRENT_ITEM++))
                    if [[ $CURRENT_ITEM -ge ${#MENU_ITEMS[@]} ]]; then
                        CURRENT_ITEM=0
                    fi
                    ;;
            esac
            ;;
        ' ') # Space - toggle selection
            if [[ ${SELECTED_ITEMS[$CURRENT_ITEM]} -eq 0 ]]; then
                SELECTED_ITEMS[$CURRENT_ITEM]=1
            else
                SELECTED_ITEMS[$CURRENT_ITEM]=0
            fi
            ;;
        'a'|'A') # Select all
            for i in "${!SELECTED_ITEMS[@]}"; do
                SELECTED_ITEMS[$i]=1
            done
            ;;
        'n'|'N') # Select none
            for i in "${!SELECTED_ITEMS[@]}"; do
                SELECTED_ITEMS[$i]=0
            done
            ;;
        ''|$'\n') # Enter - run selected
            return 1
            ;;
        'q'|'Q') # Quit
            return 2
            ;;
        # Number selection (1-7)
        [1-7])
            local idx=$((key - 1))
            if [[ $idx -lt ${#MENU_ITEMS[@]} ]]; then
                CURRENT_ITEM=$idx
                # Toggle selection
                if [[ ${SELECTED_ITEMS[$idx]} -eq 0 ]]; then
                    SELECTED_ITEMS[$idx]=1
                else
                    SELECTED_ITEMS[$idx]=0
                fi
            fi
            ;;
    esac
    
    return 0
}

# Run selected items
run_selected_items() {
    local has_selection=0
    
    # Check if anything is selected
    for selected in "${SELECTED_ITEMS[@]}"; do
        if [[ $selected -eq 1 ]]; then
            has_selection=1
            break
        fi
    done
    
    if [[ $has_selection -eq 0 ]]; then
        echo -e "\n${YELLOW}No items selected. Press any key to continue...${NC}"
        read -rsn1
        return
    fi
    
    clear
    show_header "Running Selected Tasks"
    
    # Run selected scripts
    for i in "${!SELECTED_ITEMS[@]}"; do
        if [[ ${SELECTED_ITEMS[$i]} -eq 1 ]]; then
            local cmd="${MENU_COMMANDS[$i]}"
            local script="$DOTFILES_DIR/scripts/${cmd}.sh"
            
            log_step "Running: ${MENU_ITEMS[$i]}"
            
            if [[ -f "$script" ]]; then
                # Run script and continue on error
                set +e
                bash "$script"
                local exit_code=$?
                set -e
                
                if [[ $exit_code -eq 0 ]]; then
                    log_success "${MENU_ITEMS[$i]} completed"
                else
                    log_error "${MENU_ITEMS[$i]} failed (exit code: $exit_code)"
                fi
            else
                log_error "Script not found: $script"
            fi
            
            echo ""  # Add spacing between tasks
        fi
    done
    
    show_footer "All selected tasks completed"
    echo -e "\n${GREEN}Press any key to return to menu...${NC}"
    read -rsn1
}

# Main menu loop
run_menu() {
    local CURRENT_ITEM=0
    init_selected_items
    
    # Disable cursor
    tput civis 2>/dev/null || true
    
    # Trap to restore cursor on exit
    trap 'tput cnorm 2>/dev/null || true' EXIT
    
    while true; do
        display_menu
        handle_keypress
        local result=$?
        
        case $result in
            1) # Enter pressed - run selected
                run_selected_items
                # Reset selections after running
                init_selected_items
                ;;
            2) # Quit
                clear
                echo -e "${GREEN}Thanks for using Dotfiles Manager!${NC}"
                exit 0
                ;;
        esac
    done
}

# If script is run directly, start the menu
if ! is_sourced; then
    run_menu
fi