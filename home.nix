{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
  homeTree = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/home/${path}";
in
{
  home.username = "marcoscurvello";
  home.homeDirectory = "/Users/marcoscurvello";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

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
    nodejs
    oh-my-zsh
    python3
    ripgrep
    procs
    ruby
    tree
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
  ];

  home.file = {
    "Library/Developer/Xcode/UserData/CodeSnippets" = {
      source = homeTree "Library/Developer/Xcode/UserData/CodeSnippets";
    };

    "Library/Developer/Xcode/UserData/KeyBindings" = {
      source = homeTree "Library/Developer/Xcode/UserData/KeyBindings";
    };

    "Library/Application Support/com.mitchellh.ghostty/config.ghostty" = {
      source = homeTree "Library/Application Support/com.mitchellh.ghostty/config.ghostty";
    };

    "Library/Application Support/Code/User/settings.json" = {
      source = homeTree "Library/Application Support/Code/User/settings.json";
    };

    "Library/Application Support/Code/User/keybindings.json" = {
      source = homeTree "Library/Application Support/Code/User/keybindings.json";
    };

    ".config/herdr/config.toml" = {
      source = homeTree ".config/herdr/config.toml";
    };

    ".p10k.zsh" = {
      source = homeTree ".p10k.zsh";
    };

    ".aerospace.toml" = {
      source = homeTree ".aerospace.toml";
    };

    ".gitconfig" = {
      source = homeTree ".gitconfig";
    };

    ".vimrc" = {
      source = homeTree ".vimrc";
    };

    ".config/nvim" = {
      source = homeTree ".config/nvim";
    };

    ".zshrc" = {
      source = homeTree ".zshrc";
    };

    ".zsh/functions" = {
      source = homeTree ".zsh/functions";
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
