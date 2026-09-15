# Marcos Curvello's dotfiles

My personal machine setup, managed with [`nix-darwin`](https://github.com/nix-darwin/nix-darwin) and [`home-manager`](https://github.com/nix-community/home-manager).

## Setup

Before running this on a different machine, read "Make It Yours" below.

```bash
git clone https://github.com/marcoscurvello/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dotfiles nix      # install/verify Nix
```

After the first Nix install, open a new terminal or run:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Then apply the system:

```bash
./rebuild.sh
```

## Validate

```bash
nix run .#check
```

## Daily Use

```bash
./rebuild.sh       # apply nix-darwin and Home Manager
nix run .#check    # validate without applying
nix flake update   # update pinned inputs
./rebuild.sh       # apply updated inputs
```

Experienced Nix users can run `nix run .#rebuild` directly; `rebuild.sh` just loads Nix into the current shell when needed and delegates to that flake app.

## Make It Yours

This repo is personal. If you fork or clone it for another machine, review these before the first rebuild:

- Username: change `username = "marcoscurvello"` in `flake.nix`, and update `home.username` / `home.homeDirectory` in `home.nix`.
- Host label: this repo uses `hostname = "mothership"` in `flake.nix`. Change that value if you want a different `darwinConfigurations` name.
- CPU architecture: change `darwinSystem = "aarch64-darwin"` in `flake.nix` and `nixpkgs.hostPlatform = "aarch64-darwin"` in `configuration.nix` if this is not an Apple Silicon Mac.
- Homebrew cleanup: `configuration.nix` currently uses `homebrew.onActivation.cleanup = "none"`, so rebuilds will not remove manually installed Homebrew packages. If you later switch this to `"zap"`, anything not listed in `brews` or `casks` can be removed during rebuild.
- Git identity: this repo links `home/.gitconfig`. Review it before using this setup on another machine.
- Language defaults: `home.nix` installs Node, Python, and Ruby from Nix.
- Home files: files under `home/` use destination-shaped paths, but only paths declared in `home.nix` are linked into `$HOME`.
- Existing files: Home Manager will stop if a managed destination already exists as an unmanaged file or directory. Move anything you want to preserve into `home/` before the first rebuild.
- Font: `home.nix` installs Hack Nerd Font from Nix.

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
~/Library/Application Support/Code/User/settings.json
~/Library/Application Support/Code/User/keybindings.json
~/Library/Application Support/com.mitchellh.ghostty/config.ghostty
~/Library/Developer/Xcode/UserData/CodeSnippets
~/Library/Developer/Xcode/UserData/FontAndColorThemes
~/Library/Developer/Xcode/UserData/KeyBindings
```

## Repo Layout

```text
flake.nix          # Nix flake entry point
configuration.nix  # nix-darwin system defaults and Homebrew packages
home.nix           # Home Manager packages and dotfile links
home/              # source files for explicitly declared Home Manager links
docs/              # generated/reference docs
rebuild.sh         # daily rebuild helper
dotfiles           # installer/app helper
scripts/           # Nix installer and app-specific helpers
```

## Notes

- Edit files in `~/.dotfiles`, then run `./rebuild.sh`.
- Private shell config can live in `~/.zsh_private_aliases`.
- VS Code extensions can be installed with `./dotfiles vscode extensions`.
- Xcode snippets can be synced into the repo with `xcode-sync`.
- Xcode DerivedData can be cleared with `derivedd`.
