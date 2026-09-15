#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles/home"
XCODE_USER_DATA="$HOME/Library/Developer/Xcode/UserData"

mkdir -p "$XCODE_USER_DATA"

ln -sf "$DOTFILES_DIR/Library/Developer/Xcode/UserData/FontAndColorThemes" "$XCODE_USER_DATA/FontAndColorThemes"
