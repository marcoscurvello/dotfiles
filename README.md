# Marcos Curvello's dotfiles

Personal macOS dotfiles managed with Nix flakes, Home Manager, nix-darwin, and Homebrew.

## Setup

```bash
git clone https://github.com/marcoscurvello/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dotfiles bootstrap
```

For an existing checkout:

```bash
cd ~/.dotfiles
./dotfiles nix      # install/verify Nix
./dotfiles link     # activate Home Manager dotfile links
./dotfiles darwin   # activate nix-darwin system config
```

## Daily Use

```bash
./dotfiles          # interactive menu
./dotfiles update   # pull updates, relink configs, update Homebrew
./dotfiles brew     # install/update Brewfile packages
./dotfiles link     # re-activate dotfile links
```

After a first Nix install, open a new terminal or run:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

## Managed Files

Home Manager links the main configs from this repo into:

```text
~/.zshrc
~/.gitconfig
~/.vimrc
~/.p10k.zsh
~/.aerospace.toml
~/.config/herdr/config.toml
~/.config/nvim
~/Library/Application Support/com.mitchellh.ghostty/config.ghostty
~/Library/Developer/Xcode/UserData/CodeSnippets
~/Library/Developer/Xcode/UserData/KeyBindings
```

## Repo Layout

```text
flake.nix       # Nix flake entry point
home.nix        # Home Manager dotfile links
darwin.nix      # nix-darwin system config
Brewfile        # Homebrew packages and casks
dotfiles        # command entry point
scripts/        # setup and activation scripts
zsh/            # shell config and functions
ghostty/        # Ghostty config
nvim/           # Neovim config
xcode/          # Xcode snippets, themes, and keybindings
```

## Notes

- Edit files in `~/.dotfiles`, then run `./dotfiles link`.
- Private shell config can live in `~/.zsh_private_aliases`.
- VS Code settings are synced manually with `vscode-sync`.
- Xcode snippets can be synced with `xcode-sync`.
