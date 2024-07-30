#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
XCODE_USER_DATA="$HOME/Library/Developer/Xcode/UserData"

mkdir -p "$XCODE_USER_DATA"

ln -sf "$DOTFILES_DIR/xcode/FontAndColorThemes" "$XCODE_USER_DATA/FontAndColorThemes"
