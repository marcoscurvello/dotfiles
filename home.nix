{ config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
  liveLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  home.username = "marcoscurvello";
  home.homeDirectory = "/Users/marcoscurvello";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.file = {
    "Library/Developer/Xcode/UserData/CodeSnippets" = {
      source = liveLink "xcode/CodeSnippets";
      force = true;
    };

    "Library/Developer/Xcode/UserData/KeyBindings" = {
      source = liveLink "xcode/KeyBindings";
      force = true;
    };

    "Library/Application Support/com.mitchellh.ghostty/config.ghostty" = {
      source = liveLink "ghostty/config.ghostty";
      force = true;
    };

    ".config/herdr/config.toml" = {
      source = liveLink "herdr/config.toml";
      force = true;
    };

    ".p10k.zsh" = {
      source = liveLink "p10kzsh";
      force = true;
    };

    ".aerospace.toml" = {
      source = liveLink "aerospace.toml";
      force = true;
    };

    ".gitconfig" = {
      source = liveLink "gitconfig";
      force = true;
    };

    ".vimrc" = {
      source = liveLink "vimrc";
      force = true;
    };

    ".config/nvim" = {
      source = liveLink "nvim";
      force = true;
    };

    ".zshrc" = {
      source = liveLink "zsh/zshrc";
      force = true;
    };

    ".zsh/functions" = {
      source = liveLink "zsh/functions";
      force = true;
    };
  };
}
