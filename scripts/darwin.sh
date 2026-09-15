#!/usr/bin/env bash

# Activate the nix-darwin system configuration for this dotfiles repo.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

set +e

main() {
    show_header "nix-darwin Activation"

    cd "$DOTFILES_DIR" || {
        log_error "Failed to change to dotfiles directory"
        exit 1
    }

    if ! command_exists nix; then
        log_error "Nix is not available in this shell"
        log_info "Open a new terminal after installing Nix, then retry: ./dotfiles darwin"
        exit 1
    fi

    log_step "Running darwin-rebuild from the flake..."

    local nix_bin
    nix_bin="$(command -v nix)"

    local nix_command=(
        "$nix_bin"
        --extra-experimental-features
        "nix-command flakes"
        run
        .#darwin-switch
    )

    if [[ "$EUID" -eq 0 ]]; then
        "${nix_command[@]}"
    else
        sudo "${nix_command[@]}"
    fi

    if [[ $? -eq 0 ]]; then
        log_success "nix-darwin activated successfully"
    else
        log_error "nix-darwin activation failed"
        exit 1
    fi

    show_footer "nix-darwin Activation Complete"
}

main "$@"
