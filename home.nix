{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
  homeTree = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/home/${path}";
  defaultNodeVersion = "24.21.0";
  defaultPythonVersion = "3.14.7";
  defaultRubyVersion = "4.0.6";
in
{
  home.username = "marcoscurvello";
  home.homeDirectory = "/Users/marcoscurvello";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.activation.ensureLanguageRuntimes = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

    if command -v nodenv >/dev/null 2>&1; then
      if ! nodenv versions --bare | grep -Fxq "${defaultNodeVersion}"; then
        nodenv install -s "${defaultNodeVersion}"
      fi
      nodenv global "${defaultNodeVersion}"
      nodenv rehash
    fi

    if command -v pyenv >/dev/null 2>&1; then
      if ! pyenv versions --bare | grep -Fxq "${defaultPythonVersion}"; then
        pyenv install -s "${defaultPythonVersion}"
      fi
      pyenv global "${defaultPythonVersion}"
    fi

    if command -v rbenv >/dev/null 2>&1; then
      if ! rbenv versions --bare | grep -Fxq "${defaultRubyVersion}"; then
        rbenv install -s "${defaultRubyVersion}"
      fi
      rbenv global "${defaultRubyVersion}"
      rbenv rehash
    fi
  '';

  home.packages = with pkgs; [
    bat
    dust
    eza
    fd
    fzf
    git
    delta
    htop
    httpie
    jq
    neovim
    nerd-fonts.hack
    oh-my-zsh
    ripgrep
    procs
    tree
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
  ];

  home.file = {
    "Library/Developer/Xcode/UserData/CodeSnippets" = {
      source = homeTree "Library/Developer/Xcode/UserData/CodeSnippets";
      force = true;
    };

    "Library/Developer/Xcode/UserData/KeyBindings" = {
      source = homeTree "Library/Developer/Xcode/UserData/KeyBindings";
      force = true;
    };

    "Library/Developer/Xcode/UserData/FontAndColorThemes" = {
      source = homeTree "Library/Developer/Xcode/UserData/FontAndColorThemes";
      force = true;
    };

    "Library/Application Support/com.mitchellh.ghostty/config.ghostty" = {
      source = homeTree "Library/Application Support/com.mitchellh.ghostty/config.ghostty";
      force = true;
    };

    "Library/Application Support/Code/User/settings.json" = {
      source = homeTree "Library/Application Support/Code/User/settings.json";
      force = true;
    };

    "Library/Application Support/Code/User/keybindings.json" = {
      source = homeTree "Library/Application Support/Code/User/keybindings.json";
      force = true;
    };

    ".config/herdr/config.toml" = {
      source = homeTree ".config/herdr/config.toml";
      force = true;
    };

    ".p10k.zsh" = {
      source = homeTree ".p10k.zsh";
      force = true;
    };

    ".aerospace.toml" = {
      source = homeTree ".aerospace.toml";
      force = true;
    };

    ".gitconfig" = {
      source = homeTree ".gitconfig";
      force = true;
    };

    ".vimrc" = {
      source = homeTree ".vimrc";
      force = true;
    };

    ".config/nvim" = {
      source = homeTree ".config/nvim";
      force = true;
    };

    ".zshrc" = {
      source = homeTree ".zshrc";
      force = true;
    };

    ".zsh/functions" = {
      source = homeTree ".zsh/functions";
      force = true;
    };

    ".config/zsh/nix-sources.zsh".text = ''
      export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
      export FZF_KEY_BINDINGS_FILE="${pkgs.fzf}/share/fzf/key-bindings.zsh"
      export FZF_COMPLETION_FILE="${pkgs.fzf}/share/fzf/completion.zsh"
      export POWERLEVEL10K_THEME="${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      export ZSH_AUTOSUGGESTIONS_SOURCE="${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      export ZSH_SYNTAX_HIGHLIGHTING_SOURCE="${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    '';

  };
}
