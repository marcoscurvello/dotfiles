#!/usr/bin/env bash

# Install and verify Nix for flake based dotfile activation.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/utils.sh"

set +e

load_nix_profile() {
    if [[ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        # shellcheck source=/dev/null
        source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        # shellcheck source=/dev/null
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

install_nix() {
    log_step "Checking Nix installation..."

    load_nix_profile

    if command_exists nix; then
        log_success "Nix is already installed"
        log_info "Nix version: $(nix --version)"
        return 0
    fi

    log_info "Nix not found. Installing Nix with the official macOS installer..."
    log_info "This may prompt for your password and may require opening a new terminal after installation."

    if curl -L https://nixos.org/nix/install | sh -s -- --daemon; then
        load_nix_profile
    else
        log_error "Nix installer failed"
        return 1
    fi

    if command_exists nix; then
        log_success "Nix installed successfully"
        log_info "Nix version: $(nix --version)"
    else
        log_warning "Nix installed, but this shell cannot see it yet"
        log_info "Open a new terminal, then run: ./rebuild.sh"
    fi
}

main() {
    show_header "Nix Setup"

    if ! check_macos; then
        exit 1
    fi

    install_nix

    show_footer "Nix Setup Complete"
}

main "$@"
