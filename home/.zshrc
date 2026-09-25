ZSH_DOTENV_PROMPT=false
# ENABLE POWERLEVEL10K INSTANT PROMPT
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH EXPORTS
typeset -U path
path=(
  "$HOME/.nodenv/shims"
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.dotfiles/bin"
  /usr/local/sbin
  $path
)

# HOME MANAGER SESSION
if [[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# NIX-MANAGED SHELL SOURCES
if [[ -f "$HOME/.config/zsh/nix-sources.zsh" ]]; then
  source "$HOME/.config/zsh/nix-sources.zsh"
fi

# CLAUDE - Direct execution since Node is in PATH
# Claude Code is installed globally via Homebrew npm

# ZSH THEME - Empty since we manually source powerlevel10k
ZSH_THEME=""

# ZSH PERFORMANCE
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true
COMPLETION_WAITING_DOTS=true

# ZSH PLUGINS
plugins=(
  git
  jsontools
  bundler
  dotenv
  macos
  ruby
)

# ENVIRONMENT CONFIGURATION
export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'
export BROWSER='open'

# HISTORY CONFIGURATION
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# OH-MY-ZSH
if [[ -n "${ZSH:-}" && -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# CUSTOM FUNCTIONS
fpath=($HOME/.dotfiles/home/.zsh/functions $fpath)
autoload -U $HOME/.dotfiles/home/.zsh/functions/*(:t)

# Set personal aliases, overriding those provided by oh-my-`zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# CD
alias .="open ."
alias dot="cd ~/.dotfiles"
alias dev="cd ~/Developer"

# GIT
alias branch="git symbolic-ref --short HEAD | tr -d ' \n' | pbcopy"
alias origin="git remote -v | grep origin | head -n1 | awk '{print \$2}' | tee >(pbcopy)"
alias upstream="git remote -v | grep upstream | head -n1 | awk '{print \$2}' | tee >(pbcopy)"

# EZA (modern ls replacement)
alias ls="eza -la --group-directories-first"
alias ll="eza -la --group-directories-first --icons=always --git"
alias tree="eza --tree --level=2 --icons=always"

# BAT (modern cat replacement)
alias cat="bat --paging=never --theme=default"

# MODERN CLI TOOLS
alias find="fd"               # Better find
alias grep="rg"              # Better grep
alias top="htop"             # Better top
alias du="dust"              # Better du (if installed)
alias ps="procs"             # Better ps (if installed)

# DEVELOPMENT SHORTCUTS
alias code="code ."         # Open current directory in VS Code
alias serve="python3 -m http.server 8000"  # Quick HTTP server

# PRIVATE
[[ -f ~/.zsh_private_aliases ]] && source ~/.zsh_private_aliases

# FZF CONFIGURATION
if command -v fzf &> /dev/null; then
  # Use ripgrep for fzf if available
  if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  # Enhanced fzf options
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --preview "bat --style=numbers --color=always --line-range :500 {}"
    --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284
    --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf
    --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284'

  # Load fzf key bindings and completion
  [[ -n "${FZF_KEY_BINDINGS_FILE:-}" && -f "$FZF_KEY_BINDINGS_FILE" ]] && source "$FZF_KEY_BINDINGS_FILE"
  [[ -n "${FZF_COMPLETION_FILE:-}" && -f "$FZF_COMPLETION_FILE" ]] && source "$FZF_COMPLETION_FILE"
fi

# POWERLEVEL10K
[[ -n "${POWERLEVEL10K_THEME:-}" && -f "$POWERLEVEL10K_THEME" ]] && source "$POWERLEVEL10K_THEME"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH AUTOSUGGESTIONS
[[ -n "${ZSH_AUTOSUGGESTIONS_SOURCE:-}" && -f "$ZSH_AUTOSUGGESTIONS_SOURCE" ]] && source "$ZSH_AUTOSUGGESTIONS_SOURCE"

# ZSH SYNTAX HIGHLIGHTING (must be last)
[[ -n "${ZSH_SYNTAX_HIGHLIGHTING_SOURCE:-}" && -f "$ZSH_SYNTAX_HIGHLIGHTING_SOURCE" ]] && source "$ZSH_SYNTAX_HIGHLIGHTING_SOURCE"

# CLAUDE TERMINAL WINDOW WRAPPER
[[ -f ~/.config/zsh/terminal-title-wrapper.zsh ]] && source ~/.config/zsh/terminal-title-wrapper.zsh
alias dotfiles="cd ~/.dotfiles && ./dotfiles"
