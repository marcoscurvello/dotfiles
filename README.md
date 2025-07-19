# Marcos Curvello's dotfiles

> **Automated dotfiles and development environment configuration for macOS**

![screenshot of my shell prompt](https://i.imgur.com/MmA4D9A.png)



## 🛠️ What's Included

### **Core Tools & CLI**
- **Shell**: Zsh with Oh My Zsh framework
- **Terminal**: iTerm2 with custom color schemes (MarquinSwift, Mirage)
- **Theme**: Powerlevel10k for beautiful, informative prompts
- **File Management**: eza (modern ls), bat (syntax-highlighted cat)
- **Git**: Advanced configuration with delta for enhanced diffs
- **Package Manager**: Homebrew with curated formula list

### **Development Tools**
- **Version Managers**: rbenv (Ruby), pyenv (Python), nvm (Node.js)
- **iOS Development**: Xcode themes, SwiftLint, xcbeautify, xclogparser
- **Code Editor**: VS Code with optimal settings
- **CI/CD**: Fastlane for iOS automation
- **API Testing**: Proxyman for network debugging
- **Containerization**: Docker Desktop

### **macOS Productivity**
- **Window Manager**: Aerospace (tiling window manager)
- **Borders**: JankyBorders for visual window focus
- **Stay Awake**: KeepingYouAwake (caffeine alternative)

### **Security & Privacy**
- **Private configurations** support via `~/.zsh_private_aliases`
- **Git credentials** kept separate from public configs
- **SSH configurations** excluded from version control

## 🚀 Quick Setup

### One-Command Installation
```bash
# Complete setup for a new machine - installs everything
curl -fsSL https://raw.githubusercontent.com/marcoscurvello/dotfiles/main/scripts/bootstrap.sh | bash
```

### Manual Installation
If you prefer more control:

```bash
# 1. Clone the repository
git clone https://github.com/marcoscurvello/dotfiles.git ~/.dotfiles

# 2. Navigate to dotfiles directory
cd ~/.dotfiles

# 3. Run interactive menu (recommended)
./dotfiles

# OR run specific commands:
./dotfiles bootstrap    # Full setup (same as curl command)
./dotfiles update       # Update existing installation
./dotfiles link         # Just update symlinks
```

### 🎯 New Modular System

The dotfiles now use a modular architecture. You can run individual components:

```bash
./dotfiles menu         # Interactive selection menu (default)
./dotfiles bootstrap    # Complete setup for new machine
./dotfiles update       # Update everything (git pull + brew upgrade)
./dotfiles link         # Update configuration symlinks only
./dotfiles brew         # Install/update Homebrew packages
./dotfiles macos        # Apply macOS system preferences
./dotfiles shell        # Configure shell (Zsh/Oh-My-Zsh)
./dotfiles xcode        # Setup Xcode themes and snippets
```

## 📋 What Gets Installed

### Homebrew Packages
| Category | Tools |
|----------|-------|
| **CLI Tools** | eza, bat, jq, gh, git-delta |
| **Development** | rbenv, pyenv, powerlevel10k, zsh-autosuggestions |
| **iOS/Swift** | fastlane, xclogparser, xcbeautify, swiftlint |
| **Network** | aircrack-ng |
| **UI** | janky borders (window borders) |

### Applications (Casks)
| Category | Applications |
|----------|-------------|
| **Development** | Visual Studio Code, Xcode (via xcodes), Docker |
| **Terminal** | iTerm2 |
| **Productivity** | KeepingYouAwake |
| **Network** | Proxyman |
| **Window Management** | AeroSpace |

### Configuration Files
```
~/.gitconfig          # Git configuration with delta
~/.zshrc              # Zsh shell configuration
~/.p10k.zsh           # Powerlevel10k theme settings
~/.vimrc              # Vim configuration
~/.aerospace.toml     # Window manager settings
```

## 🎯 Customization

### Adding Private Configurations
Create `~/.zsh_private_aliases` for personal aliases and sensitive configurations:
```bash
# Example private aliases
alias work="cd ~/work/super-secret-project"
export API_KEY="your-secret-key"
```

### Custom Functions
Add new shell functions to `~/.dotfiles/zsh/functions/`. Examples included:
- `weather` - Get weather for any city
- `fkill` - Fuzzy process killing
- `cleanxcode` - Clean Xcode derived data
- `ip` - Get your IP address

### Customizing Configurations
1. Edit files in the `~/.dotfiles` directory
2. Run `./dotfiles link` to update symlinks
3. Restart your terminal or source configs

### Xcode Snippets
Sync your Xcode code snippets with git:
```bash
# After creating/modifying snippets in Xcode
xcode-sync

# This will sync snippets to git and optionally commit them
```

## 🗂️ Repository Structure

```
~/.dotfiles/
├── dotfiles               # Main entry point (interactive menu + commands)
├── scripts/               # Modular setup scripts
│   ├── bootstrap.sh       # Complete setup for new machines
│   ├── update.sh          # Update existing installation
│   ├── link.sh            # Symlink management
│   ├── brew.sh            # Homebrew package management
│   ├── macos.sh           # macOS system preferences
│   ├── shell.sh           # Shell configuration
│   └── xcode.sh           # Xcode setup
├── lib/                   # Shared libraries
│   ├── utils.sh           # Common functions and logging
│   └── menu.sh            # Interactive menu system
├── install                # Legacy Dotbot runner (will be removed)
├── setup                  # Legacy setup script (will be removed)
├── install.conf.yaml      # Dotbot configuration
├── Brewfile               # Homebrew dependencies
├── zsh/
│   ├── zshrc              # Main Zsh configuration
│   └── functions/         # Custom shell functions
│       └── xcode-sync     # Sync Xcode snippets to git
├── xcode/
│   ├── FontAndColorThemes/# Xcode color themes
│   ├── CodeSnippets/      # Xcode code snippets
│   ├── KeyBindings/       # Xcode key bindings
│   └── snippets.md        # Snippet documentation
├── iterm/
│   └── com.googlecode.iterm2.plist  # iTerm2 settings
├── vscode/                # VS Code settings
│   ├── settings.json
│   └── keybindings.json
├── gitconfig              # Git configuration
├── vimrc                  # Vim configuration
├── p10kzsh                # Powerlevel10k configuration
└── aerospace.toml         # Window manager configuration
```

## 🚨 Important Notes

### Before Installation
- **Backup existing dotfiles** - This will overwrite existing configurations
- **Close all terminal sessions** after installation
- **Restart your terminal** to see changes

### Sensitive Information
This repository is designed to be **publicly shareable**. Sensitive information should go in:
- `~/.zsh_private_aliases` (for private shell aliases)
- Git credentials will be prompted for separately
- SSH keys are not managed by this repository

### macOS Version Compatibility
- **Tested on**: macOS Sonoma (14.x), Ventura (13.x)
- **Apple Silicon**: Fully compatible with M1/M2/M3 Macs
- **Intel Macs**: Compatible but may require architecture-specific adjustments

## 🆘 Troubleshooting

### Common Issues

**Permission denied**
```bash
# Fix permissions for Homebrew
sudo chown -R $(whoami) /opt/homebrew
```

**Zsh configuration not loading**
```bash
# Source the configuration manually
source ~/.zshrc
```

## 📚 Learning Resources

### Understanding the Tools
- [Oh My Zsh Guide](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Powerlevel10k Configuration](https://github.com/romkatv/powerlevel10k)
- [AeroSpace Window Manager](https://github.com/nikitabobko/AeroSpace)

### Advanced Configuration
- [Dotbot Documentation](https://github.com/anishathalye/dotbot)
- [Git Delta Features](https://github.com/dandavison/delta)
- [iTerm2 Customization](https://iterm2.com/documentation.html)

## 🙏 Acknowledgements

- [Dotbot](https://github.com/anishathalye/dotbot) - Dotfiles installation framework
- [Homebrew](https://brew.sh) - Package manager for macOS
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) - Tiling window manager

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---