{ username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  system.primaryUser = username;
  system.stateVersion = 6;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.activationScripts.postActivation.text = ''
    mkdir -p "/Users/${username}/Desktop/Screenshots"
    chown "${username}:staff" "/Users/${username}/Desktop/Screenshots"
  '';

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      launchanim = false;
      mineffect = "scale";
      showhidden = true;
    };

    finder = {
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };

    screencapture = {
      disable-shadow = true;
      location = "/Users/${username}/Desktop/Screenshots";
      type = "png";
    };

    trackpad.Clicking = true;

    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      "com.apple.mouse.tapBehavior" = 1;
    };
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
      extraEnv.HOMEBREW_NO_ENV_HINTS = "1";
    };
    taps = [
      "anomalyco/tap"
      "FelixKratz/formulae"
      "getsentry/xcodebuildmcp"
      "nikitabobko/tap"
      "rjyo/moshi"
    ];
    brews = [
      "aircrack-ng"
      "anomalyco/tap/opencode"
      "borders"
      "curl"
      "fastlane"
      "ffmpeg"
      "fonttools"
      "getsentry/xcodebuildmcp/xcodebuildmcp"
      "gh"
      "herdr"
      "imagemagick"
      "mas"
      "mosh"
      "node-build"
      "nodenv"
      "ollama"
      "pnpm"
      "sourcery"
      "swiftgen"
      "swiftlint"
      "swiftly"
      "wget"
      "xcbeautify"
      "xclogparser"
      "xcodes"
    ];
    casks = [
      "bruno"
      "claude-code"
      "codex"
      "docker-desktop"
      "font-fira-code-nerd-font"
      "ghostty"
      "keepingyouawake"
      "ngrok"
      "nikitabobko/tap/aerospace"
      "opensuperwhisper"
      "proxyman"
      "visual-studio-code"
      "xcodes-app"
    ];
  };
}
