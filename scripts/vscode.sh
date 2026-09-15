#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/../lib/utils.sh"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
DOTFILES_CODE_DIR="$DOTFILES_DIR/home/Library/Application Support/Code"
DOTFILES_VSCODE_USER_DIR="$DOTFILES_CODE_DIR/User"
DOTFILES_VSCODE_EXTENSIONS="$DOTFILES_CODE_DIR/extensions.txt"

check_vscode() {
    command -v code >/dev/null 2>&1
}

install_vscode_extensions() {
    log_info "Installing VS Code extensions..."

    if [[ ! -f "$DOTFILES_VSCODE_EXTENSIONS" ]]; then
        log_warning "No extensions file found: $DOTFILES_VSCODE_EXTENSIONS"
        return 0
    fi

    if ! check_vscode; then
        log_error "VS Code CLI not found. Open VS Code and install the 'code' shell command first."
        return 1
    fi

    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        if [[ "$line" =~ code[[:space:]]+--install-extension[[:space:]]+([^[:space:]]+) ]]; then
            local extension="${BASH_REMATCH[1]}"
            log_info "Installing extension: $extension"
            code --install-extension "$extension" || log_warning "Failed to install $extension"
        else
            log_warning "Skipping unrecognized extension line: $line"
        fi
    done < "$DOTFILES_VSCODE_EXTENSIONS"

    log_success "VS Code extension installation complete"
}

show_status() {
    log_info "VS Code managed files:"

    for file in settings.json keybindings.json; do
        local source="$DOTFILES_VSCODE_USER_DIR/$file"
        local target="$VSCODE_USER_DIR/$file"

        if [[ ! -e "$source" ]]; then
            log_warning "Missing source: $source"
        elif [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
            log_success "$file is linked"
        elif [[ -e "$target" && "$source" -ef "$target" ]]; then
            log_success "$file is linked"
        elif [[ -e "$target" ]] && diff -q "$source" "$target" >/dev/null 2>&1; then
            log_warning "$file has matching content but is not linked"
        elif [[ -e "$target" ]]; then
            log_warning "$file differs from the managed source"
        else
            log_warning "$file is not present in VS Code's user directory"
        fi
    done
}

main() {
    case "${1:-extensions}" in
        extensions)
            install_vscode_extensions
            ;;
        status)
            show_status
            ;;
        *)
            log_error "Unknown command: $1"
            echo "Usage: $0 [extensions|status]"
            exit 1
            ;;
    esac
}

main "$@"
