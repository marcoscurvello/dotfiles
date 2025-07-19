#!/usr/bin/env bash

# Update dotfiles and all components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

# Don't exit on error for this script
set +e

# Parse command line arguments
SKIP_BREW=false
for arg in "$@"; do
    case $arg in
        --no-brew)
            SKIP_BREW=true
            shift
            ;;
    esac
done

# Update git repository
update_repository() {
    log_step "Updating dotfiles repository..."
    
    cd "$DOTFILES_DIR" || {
        log_error "Failed to change to dotfiles directory"
        return 1
    }
    
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        log_warning "You have uncommitted changes:"
        git status --short
        echo ""
        
        if confirm "Stash changes and continue?" "y"; then
            log_info "Stashing changes..."
            git stash push -m "Stashed by update script $(date '+%Y-%m-%d %H:%M:%S')"
        else
            log_error "Update cancelled - please commit or stash your changes"
            return 1
        fi
    fi
    
    # Fetch and check for updates
    log_info "Fetching updates..."
    git fetch origin
    
    local LOCAL=$(git rev-parse @)
    local REMOTE=$(git rev-parse @{u})
    local BASE=$(git merge-base @ @{u})
    
    if [[ $LOCAL = $REMOTE ]]; then
        log_success "Already up to date"
    elif [[ $LOCAL = $BASE ]]; then
        log_info "Updates available, pulling..."
        if git pull --rebase; then
            log_success "Repository updated successfully"
        else
            log_error "Failed to update repository"
            return 1
        fi
    elif [[ $REMOTE = $BASE ]]; then
        log_warning "You have local commits not pushed to remote"
        log_info "Your changes will be preserved"
    else
        log_warning "Diverged from remote, attempting rebase..."
        if git pull --rebase; then
            log_success "Repository updated and rebased"
        else
            log_error "Rebase failed - manual intervention required"
            return 1
        fi
    fi
    
    # Restore stashed changes if any
    if git stash list | grep -q "Stashed by update script"; then
        log_info "Restoring stashed changes..."
        git stash pop
    fi
    
    return 0
}

# Update Homebrew packages
update_homebrew() {
    if [[ "$SKIP_BREW" == true ]]; then
        log_info "Skipping Homebrew update (--no-brew flag)"
        return 0
    fi
    
    log_step "Updating Homebrew packages..."
    
    if ! is_homebrew_installed; then
        log_warning "Homebrew not installed, skipping"
        return 0
    fi
    
    # Update Homebrew itself
    log_info "Updating Homebrew..."
    brew update
    
    # Upgrade all packages
    log_info "Upgrading packages..."
    brew upgrade
    
    # Upgrade casks
    log_info "Upgrading cask applications..."
    brew upgrade --cask
    
    # Cleanup old versions
    log_info "Cleaning up old versions..."
    brew cleanup
    
    log_success "Homebrew packages updated"
}

# Update Oh My Zsh
update_oh_my_zsh() {
    log_step "Updating Oh My Zsh..."
    
    if ! is_oh_my_zsh_installed; then
        log_warning "Oh My Zsh not installed, skipping"
        return 0
    fi
    
    # Update Oh My Zsh
    if [[ -f "$HOME/.oh-my-zsh/tools/upgrade.sh" ]]; then
        env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/upgrade.sh" 2>/dev/null || {
            log_warning "Failed to update Oh My Zsh automatically"
            log_info "You can update manually with: omz update"
        }
    else
        log_info "Run 'omz update' to update Oh My Zsh"
    fi
}

# Update symlinks
update_symlinks() {
    log_step "Updating configuration symlinks..."
    
    # Run link script
    if bash "$SCRIPT_DIR/link.sh"; then
        log_success "Symlinks updated"
    else
        log_warning "Some symlinks failed to update"
    fi
}

# Show what changed
show_changes() {
    log_step "Recent changes in dotfiles..."
    
    cd "$DOTFILES_DIR" || return
    
    # Show recent commits
    local commits=$(git log --oneline -5 --pretty=format:"  %C(yellow)%h%C(reset) - %s %C(green)(%cr)%C(reset)")
    if [[ -n "$commits" ]]; then
        echo -e "$commits"
    else
        log_info "No recent changes"
    fi
}

# Main function
main() {
    show_header "Updating Dotfiles Environment"
    
    # Update repository
    if ! update_repository; then
        log_error "Repository update failed"
        exit 1
    fi
    
    # Update symlinks (in case config structure changed)
    update_symlinks
    
    # Update Homebrew
    update_homebrew
    
    # Update Oh My Zsh
    update_oh_my_zsh
    
    # Show recent changes
    show_changes
    
    show_footer "Update Complete"
    
    # Reminder
    echo ""
    log_info "${BOLD}Reminder:${NC}"
    log_info "• Restart your terminal to ensure all changes take effect"
    log_info "• Run 'xcode-sync' if you've made Xcode snippet changes"
    log_info "• Check log file for any warnings: $LOG_FILE"
}

# Run main function
main "$@"